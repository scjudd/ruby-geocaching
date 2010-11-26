# encoding: utf-8

require "cgi"
require "net/http"
require "timeout"

module Geocaching
  # The {HTTP} class handles the HTTP communication with geocaching.com.
  class HTTP
    # An array of user agent strings.  A random one is chosen.
    USER_AGENTS = [
      "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)",
      "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)",
      "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1)",
      "Mozilla/5.0 (compatible; Konqueror/3.2; Linux 2.6.2) (KHTML, like Gecko)",
      "Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/125.2 (KHTML, like Gecko) Safari/125.8",
      "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/525.13 (KHTML, like Gecko) Chrome/0.A.B.C Safari/525.13",
      "Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.0.10) Gecko/2009042316 Firefox/3.0.10",
      "Mozilla/5.0 (X11; U; Linux i586; en-US; rv:1.7.3) Gecko/20040924 Epiphany/1.4.4 (Ubuntu)",
      "Opera/9.80 (Macintosh; Intel Mac OS X; U; en) Presto/2.2.15 Version/10.00"
    ]

    # The user agent sent with each request.
    @user_agent = nil

    # Timeout for sending and receiving HTTP data.
    @timeout = 8

    class << self
      attr_accessor :user_agent, :timeout, :username, :password

      # Returns the singleton instance of this class.
      #
      # @return [HTTP] Singleton instance of this class
      def instance
        @instance ||= new
      end

      # Alias for:
      #
      #  Geocaching::HTTP.username = username
      #  Geocaching::HTTP.password = password
      #  Geocaching::HTTP.instance.login
      def login(username = nil, password = nil)
        self.username, self.password = username, password if username && password
        self.instance.login
      end

      # Alias for +Geocaching::HTTP.instance.logout+.
      def logout
        self.instance.logout
      end

      # Alias for +Geocaching::HTTP.instance.loggedin?+.
      def loggedin?
        self.instance.loggedin?
      end

      # Alias for +Geocaching::HTTP.instance.get+.
      def get(path)
        self.instance.get(path)
      end

      # Alias for +Geocaching::HTTP.instance.post+.
      def post(path, data = {})
        self.instance.post(path, data)
      end

      # Converts HTML entities to the corresponding UTF-8 symbols.
      #
      # @return [String] The converted string
      def unescape(str)
        str = str.force_encoding("UTF-8") if str.respond_to?(:force_encoding)
        str = str.gsub(/&#(\d{3});/) { [$1.to_i].pack("U") }
        CGI.unescapeHTML(str)
      end
    end

    # Creates a new instance.
    def initialize
      @loggedin = false
      @cookie = nil
    end

    # Logs in into geocaching.com.  Username and password need to be set
    # before calling this method.
    #
    #  HTTP.username = "username"
    #  HTTP.password = "password"
    #
    # @return [void]
    # @raise [ArgumentError] Username or password missing
    def login
      raise ArgumentError, "Missing username" unless self.class.username
      raise ArgumentError, "Missing password" unless self.class.password

      raise LoginError, "Already logged in" if @loggedin

      resp, data = post("/login/default.aspx", {
        "ctl00$ContentBody$myUsername"  => self.class.username,
        "ctl00$ContentBody$myPassword"  => self.class.password,
        "ctl00$ContentBody$Button1"     => "Login",
        "ctl00$ContentBody$cookie"      => "on"
      })

      @cookie = resp.response["set-cookie"]
      @loggedin = true
    end

    # Logs out from geocaching.com.
    #
    # @return [void]
    def logout
      raise LoginError, "Not logged in" unless @loggedin

      @loggedin = false
      @cookie = nil

      get("/login/default.aspx?RESET=Y")
    end

    # Returns whether you‘ve already logged in.
    #
    # @return [Boolean] Already logged in?
    def loggedin?
      @loggedin and @cookie
    end

    # Sends a GET request to +path+.  The authentication cookie is sent
    # with the request if available.
    #
    # @param [String] path Request path
    # @return [Net::HTTP::Response] Reponse object from +Net::HTTP+
    # @return [String] Actual content
    def get(path)
      resp = data = nil
      header = default_header
      header["Cookie"] = @cookie if @cookie

      begin
        Timeout::timeout(self.class.timeout) do
          resp, data = http.get(path, header)
        end
      rescue Timeout::Error
        raise TimeoutError, "Timeout hit for GET #{path}"
      rescue
        raise HTTPError
      end

      unless resp.kind_of?(Net::HTTPSuccess) or resp.kind_of?(Net::HTTPRedirection)
        raise HTTPError
      end

      [resp, data]
    end

    # Sends a POST request to +path+ with the data given in the
    # +params+ hash.  The authentication cookie is sent with the
    # request if available.
    #
    # Before sending the POST request, a GET request is sent to obtain the
    # information like +__VIEWPORT+ that are used on geocaching.com to protect
    # from Cross Site Request Forgery.
    #
    # @return [Net::HTTP::Response] Reponse object from +Net::HTTP+
    # @return [String] Actual content
    # @raise [Geocaching::TimeoutError] Timeout hit
    # @raise [Geocaching::HTTPError] HTTP request failed
    def post(path, params = {})
      params = params.merge(metadata(path)).map { |k,v| "#{k}=#{v}" }.join("&")
      resp = data = nil

      header = default_header
      header["Cookie"] = @cookie if @cookie

      begin
        Timeout::timeout(self.class.timeout) do
          resp, data = http.post(path, params, header)
        end
      rescue Timeout::Error
        raise TimeoutError, "Timeout hit for POST #{path}"
      rescue
        raise HTTPError
      end

      unless resp.kind_of?(Net::HTTPSuccess)
        raise HTTPError
      end

      [resp, data]
    end

  private

    # Sends a GET request to +path+ to obtain form meta data used on
    # geocaching.com to protect from CSRF.
    #
    # @return [Hash] Meta information
    def metadata(path)
      resp, data = get(path)
      meta = {}

      data.scan(/<input type="hidden" name="__([A-Z]+)" id="__[A-Z]+" value="(.*?)" \/>/).each do |match|
        meta["__#{match[0]}"] = CGI.escape(match[1])
      end

      meta
    end

    # Returns the user agent string to use for the HTTP requests.  If no
    # user agent is set explicitly, a random one is chosen.
    #
    # @return [String] User agent
    def user_agent
      self.class.user_agent ||= USER_AGENTS.shuffle.first
    end

    # Returns an hash with the HTTP headers sent with each request.
    #
    # @return [Hash] Default HTTP headers
    def default_header
      {
        "User-Agent" => user_agent
      }
    end

    # Returns the instance of {Net::HTTP} or creates a new one for
    # +www.geocaching.com+.
    #
    # @return [Net::HTTP]
    def http
      @http ||= begin
        Net::HTTP.new("www.geocaching.com")
      end
    end
  end
end
