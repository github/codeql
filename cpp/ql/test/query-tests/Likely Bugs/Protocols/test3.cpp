#include "asio/boost_simulation.hpp"

// examples from the qhelp...

void useTLS_bad()
{
	boost::asio::ssl::context ctx(boost::asio::ssl::context::tls);
	ctx.set_options(boost::asio::ssl::context::no_tlsv1); // BAD: missing no_tlsv1_1

	// ...
}

void useTLS_good()
{
	boost::asio::ssl::context ctx(boost::asio::ssl::context::tls);
	ctx.set_options(boost::asio::ssl::context::no_tlsv1 | boost::asio::ssl::context::no_tlsv1_1); // GOOD

	// ...
}
