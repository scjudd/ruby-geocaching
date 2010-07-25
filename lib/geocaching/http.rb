require "cgi"
require "net/http"
require "timeout"

module Geocaching
  class HTTP
    # The user agent sent with each request.
    @user_agent = "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.0.13) Gecko/2009073022 Firefox/3.0.13 (.NET CLR 3.5.30729)"

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
        CGI.unescapeHTML(str.gsub(/&#(\d{3});/) { [$1.to_i].pack("U") })
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
    # @raise [Geocaching::LoginError] Already logged in
    # @raise [Geocaching::TimeoutError] Timeout hit
    # @raise [Geocaching::HTTPError] HTTP request failed
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
    # @raise [Geocaching::LoginError] Not logged in
    # @raise [Geocaching::TimeoutError] Timeout hit
    # @raise [Geocaching::HTTPError] HTTP request failed
    def logout
      raise LoginError, "Not logged in" unless @loggedin

      @loggedin = false
      @cookie = nil

      get("/login/default.aspx?RESET=Y")
    end

    # Returns whether this lib is logged in as a user.
    #
    # @return [Boolean] Logged in?
    def loggedin?
      @loggedin and @cookie
    end

    # Sends a GET request to +path+.  The authentication cookie is sent
    # with the request if available.
    #
    # @param [String] path
    # @return [Net::HTTP::Response] Reponse object from +Net::HTTP+
    # @return [String] Actual content
    # @raise [Geocaching::TimeoutError] Timeout hit
    # @raise [Geocaching::HTTPError] HTTP request failed
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

    # Returns an hash with the HTTP headers sent with each request.
    #
    # @return [Hash] Default HTTP headers
    def default_header
      {
        "User-Agent" => self.class.user_agent
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
