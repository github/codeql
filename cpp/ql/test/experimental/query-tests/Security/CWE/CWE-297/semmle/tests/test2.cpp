namespace std
{
  class string{};
}
namespace boost
{
  namespace asio
  {
    namespace ssl
    {
      typedef int verify_mode;
      const int verify_peer = 1;
      class rfc2818_verification
      {
      public:
        typedef bool result_type;
        explicit rfc2818_verification(const std::string& host) {}
      };
      class host_name_verification
      {
      public:
        typedef bool result_type;
        explicit host_name_verification(const std::string& host) {}
      };
      class stream
      {
      public:
        stream() {}
        void set_verify_mode(verify_mode v) {}
        template <typename VerifyCallback>
        void set_verify_callback(VerifyCallback callback) {}
      };
    }
  }
}
/*
void goodTest1(boost::asio::ssl::stream  sock){ // GOOD
  sock.set_verify_mode(boost::asio::ssl::verify_peer);
  sock.set_verify_callback(boost::asio::ssl::host_name_verification("host.name"));
}
void goodTest2(boost::asio::ssl::stream  sock){ // GOOD
  sock.set_verify_mode(boost::asio::ssl::verify_peer);
  sock.set_verify_callback(boost::asio::ssl::rfc2818_verification("host.name"));
}
*/
void badTest1(boost::asio::ssl::stream  sock){ // BAD
  sock.set_verify_mode(boost::asio::ssl::verify_peer);
}
