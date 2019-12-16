
void useTLS_bad()
{
	boost::asio::ssl::context ctx(boost::asio::ssl::context::tls);
	ctx.set_options(boost::asio::ssl::context::no_tlsv1); // BAD: missing no_tlsv1_1

	// ...
}
