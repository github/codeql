#include "asio/boost_simulation.hpp"

void good1()
{
	// GOOD
	boost::asio::ssl::context::method m = boost::asio::ssl::context::sslv23;
	boost::asio::ssl::context ctx(m);
	ctx.set_options(boost::asio::ssl::context::no_tlsv1 | boost::asio::ssl::context::no_tlsv1_1 | boost::asio::ssl::context::no_sslv3);
}

void bad1()
{
	// BAD: missing disable SSLv3
	boost::asio::ssl::context::method m = boost::asio::ssl::context::sslv23;
	boost::asio::ssl::context ctx(m);
	ctx.set_options(boost::asio::ssl::context::no_tlsv1 | boost::asio::ssl::context::no_tlsv1_1);
}

void good2()
{
	// GOOD [FALSE POSITIVE x 3]
	boost::asio::ssl::context::options opts = boost::asio::ssl::context::no_tlsv1 | boost::asio::ssl::context::no_tlsv1_1 | boost::asio::ssl::context::no_sslv3;
	boost::asio::ssl::context ctx(boost::asio::ssl::context::sslv23);
	ctx.set_options(opts);
}

void bad2()
{
	// BAD: missing disable SSLv3 [WITH FALSE POSITIVE x 2]
	boost::asio::ssl::context::options opts = boost::asio::ssl::context::no_tlsv1 | boost::asio::ssl::context::no_tlsv1_1;
	boost::asio::ssl::context ctx(boost::asio::ssl::context::sslv23);
	ctx.set_options(opts);
}

void good3()
{
	// GOOD
	boost::asio::ssl::context *ctx = new boost::asio::ssl::context(boost::asio::ssl::context::sslv23);
	ctx->set_options(boost::asio::ssl::context::no_tlsv1 | boost::asio::ssl::context::no_tlsv1_1 | boost::asio::ssl::context::no_sslv3);
}

void bad3()
{
	// BAD: missing disable SSLv3
	boost::asio::ssl::context *ctx = new boost::asio::ssl::context(boost::asio::ssl::context::sslv23);
	ctx->set_options(boost::asio::ssl::context::no_tlsv1 | boost::asio::ssl::context::no_tlsv1_1);
}

void bad4()
{
	// BAD: missing disable SSLv3
	boost::asio::ssl::context ctx(boost::asio::ssl::context::sslv23);
}


