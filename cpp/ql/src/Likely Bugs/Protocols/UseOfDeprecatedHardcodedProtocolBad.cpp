
void useProtocol_bad()
{
	boost::asio::ssl::context ctx_sslv2(boost::asio::ssl::context::sslv2); // BAD: outdated protocol

	// ...
}
