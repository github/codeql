using uint16_t = unsigned short;
using int64_t = long long;
using size_t = unsigned long;
using uint8_t = unsigned char;
using int32_t = int;
using uint32_t = unsigned int;

namespace std
{
  class string
  {
  public:
    string();
    string(const char *);
    ~string();
  };

  template <typename K, typename V>
  class map
  {
  public:
    map();
    ~map();

    V& operator[](const K& key);
  };

  template <typename T>
  class vector
  {
  public:
    vector();
    ~vector();

    T& operator[](size_t);
  };

  template<typename T>
  class unique_ptr {
  public:
    unique_ptr();
    ~unique_ptr();

    T* get();
  };
}

namespace Azure
{
  template <typename T>
    class Nullable
    {
    public:
      Nullable();
      Nullable(const T);
      Nullable(const Nullable &);
      ~Nullable();
      Nullable (Nullable &&);
      Nullable & operator= (const Nullable &);
      bool HasValue() const;
      const T & Value () const;
      T& Value ();
      const T * operator-> () const;
      T * operator-> ();
      const T & operator* () const;
      T & operator* ();
    };

  namespace Core
  {
    class Url
    {
    public:
      Url();
      Url(const std::string &);
      void AppendPath(const std::string &encodedPath);
      void AppendQueryParameter(const std::string &encodedKey,
                                const std::string &encodedValue);

      static std::string Url::Decode(const std::string &value);
      static std::string Url::Encode(const std::string &value,
                                     const std::string &doNotEncodeSymbols = "");

      std::string Url::GetAbsoluteUrl() const;
      const std::string &GetHost() const;
      const std::string &GetPath() const;
      uint16_t GetPort() const;
      std::map<std::string, std::string> GetQueryParameters() const;
      std::string Url::GetRelativeUrl() const;
      const std::string &GetScheme() const;
      void RemoveQueryParameter(const std::string &encodedKey);
      void SetHost(const std::string &encodedHost);
      void SetPath(const std::string &encodedPath);
      void SetPort(uint16_t port);
      void SetQueryParameters(std::map<std::string, std::string> queryParameters);
      void SetScheme(const std::string &scheme);
    };

    class Context
    {
    public:
      Context();
    };

    namespace IO
    {
      class BodyStream
      {
      public:
        virtual ~BodyStream();
        virtual int64_t Length() const = 0;
        virtual void Rewind();
        size_t Read(uint8_t *buffer, size_t count, Azure::Core::Context const &context = Azure::Core::Context());
        size_t ReadToCount(uint8_t *buffer, size_t count, Azure::Core::Context const &context = Azure::Core::Context());
        std::vector<uint8_t> ReadToEnd(Azure::Core::Context const &context = Azure::Core::Context());
      };
    }

    enum class HttpStatusCode {
      None = 0,
      Continue = 100,
      SwitchingProtocols = 101,
      Processing = 102,
      EarlyHints = 103,
      OK = 200,
      Created = 201,
      Accepted = 202,
      NonAuthoritativeInformation = 203,
      NoContent = 204,
      ResetContent = 205,
      PartialContent = 206,
      MultiStatus = 207,
      AlreadyReported = 208,
      IMUsed = 226,
      MultipleChoices = 300,
      MovedPermanently = 301,
      Found = 302,
      SeeOther = 303,
      NotModified = 304,
      UseProxy = 305,
      TemporaryRedirect = 307,
      PermanentRedirect = 308,
      BadRequest = 400,
      Unauthorized = 401,
      PaymentRequired = 402,
      Forbidden = 403,
      NotFound = 404,
      MethodNotAllowed = 405,
      NotAcceptable = 406,
      ProxyAuthenticationRequired = 407,
      RequestTimeout = 408,
      Conflict = 409,
      Gone = 410,
      LengthRequired = 411,
      PreconditionFailed = 412,
      PayloadTooLarge = 413,
      URITooLong = 414,
      UnsupportedMediaType = 415,
      RangeNotSatisfiable = 416,
      ExpectationFailed = 417,
      MisdirectedRequest = 421,
      UnprocessableEntity = 422,
      Locked = 423,
      FailedDependency = 424,
      TooEarly = 425,
      UpgradeRequired = 426,
      PreconditionRequired = 428,
      TooManyRequests = 429,
      RequestHeaderFieldsTooLarge = 431,
      UnavailableForLegalReasons = 451,
      InternalServerError = 500,
      NotImplemented = 501,
      BadGateway = 502,
      ServiceUnavailable = 503,
      GatewayTimeout = 504,
      HTTPVersionNotSupported = 505,
      VariantAlsoNegotiates = 506,
      InsufficientStorage = 507,
      LoopDetected = 508,
      NotExtended = 510,
      NetworkAuthenticationRequired = 511
    };

    namespace Http
    {
      class HttpMethod
      {
      public:
        HttpMethod(std::string value);
        bool operator==(const HttpMethod &other) const;
        bool operator!=(const HttpMethod &other) const;
        const std::string &ToString() const;
      };

      extern const HttpMethod Get;
      extern const HttpMethod Head;
      extern const HttpMethod Post;
      extern const HttpMethod Put;
      extern const HttpMethod Delete;
      extern const HttpMethod Patch;
      extern const HttpMethod Options;

      class Request
      {
      public:
        explicit Request(HttpMethod httpMethod,
                         Url url);
        explicit Request(HttpMethod httpMethod,
                         Url url,
                         bool shouldBufferResponse);
        explicit Request(HttpMethod httpMethod,
                         Url url,
                         IO::BodyStream *bodyStream);
        explicit Request(HttpMethod httpMethod,
                         Url url,
                         IO::BodyStream *bodyStream,
                         bool shouldBufferResponse);
        std::map<std::string, std::string> GetHeaders () const;
        Azure::Nullable<std::string> GetHeader(std::string const &name);
        IO::BodyStream * GetBodyStream();
        Azure::Core::IO::BodyStream const* GetBodyStream () const;
      };

      class RawResponse {
        public:
        RawResponse (int32_t majorVersion, int32_t minorVersion, HttpStatusCode statusCode, std::string const &reasonPhrase);
        RawResponse (RawResponse const &response);
        RawResponse (RawResponse &&response);
        ~RawResponse ();
        void SetHeader (std::string const &name, std::string const &value);
        void SetBodyStream (std::unique_ptr< Azure::Core::IO::BodyStream > stream);
        void SetBody (std::vector< uint8_t > body);
        uint32_t GetMajorVersion () const;
        uint32_t GetMinorVersion () const;
        HttpStatusCode GetStatusCode () const;
        std::string const & GetReasonPhrase () const;
        std::map<std::string, std::string>& GetHeaders () const;
        std::unique_ptr<Azure::Core::IO::BodyStream> ExtractBodyStream ();
        std::vector<uint8_t> & GetBody ();
        std::vector<uint8_t> const& GetBody() const;
      };
    }
  }
}

void sink(char);
void sink(std::string);
void sink(std::vector<uint8_t>);
void sink(Azure::Nullable<std::string>);

void test_BodyStream() {
  Azure::Core::Http::Request request(Azure::Core::Http::Get, Azure::Core::Url("http://example.com"));
  Azure::Core::IO::BodyStream * resp = request.GetBodyStream();
  
  {
    unsigned char buffer[1024];
    resp->Read(buffer, sizeof(buffer));
    sink(*buffer); // $ ir
  }
  {
    unsigned char buffer[1024];
    resp->ReadToCount(buffer, sizeof(buffer));
    sink(*buffer); // $ ir
  }
  {
    std::vector<unsigned char> vec = resp->ReadToEnd();
    sink(vec); // $ ir
  }
}

void test_RawResponse(Azure::Core::Http::RawResponse& resp) {
  {
    std::map<std::string, std::string> body = resp.GetHeaders();
    sink(body["Content-Type"]); // $ ir
  }
  {
    std::vector<uint8_t> body = resp.GetBody();
    sink(body); // $ ir
  }
  {
    std::unique_ptr<Azure::Core::IO::BodyStream> bodyStream = resp.ExtractBodyStream();
    sink(bodyStream.get()->ReadToEnd()); // $ ir
  }
}

void test_GetHeader() {
  Azure::Core::Http::Request request(Azure::Core::Http::Get, Azure::Core::Url("http://example.com"));
  {
    auto headerValue = request.GetHeader("Content-Type").Value();
    sink(headerValue); // $ ir
  }
  {
    std::map<std::string, std::string> headers = request.GetHeaders();
    std::string contentType = headers["Content-Type"];
    sink(contentType); // $ ir
  }
}