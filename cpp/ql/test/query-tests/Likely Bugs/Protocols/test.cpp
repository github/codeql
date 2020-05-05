#include "asio/boost_simulation.hpp"

void SetOptionsNoOldTls(boost::asio::ssl::context& ctx)
{
	ctx.set_options(boost::asio::ssl::context::no_tlsv1);
	ctx.set_options(boost::asio::ssl::context::no_tlsv1_1);
}

void TestProperConfiguration_inter_CorrectUsage01()
{
	boost::asio::ssl::context ctx(boost::asio::ssl::context::tls_client);
	SetOptionsNoOldTls(ctx);
}

void TestProperConfiguration_inter_CorrectUsage02()
{
	boost::asio::ssl::context ctx(boost::asio::ssl::context::sslv23);
	ctx.set_options(boost::asio::ssl::context::no_tlsv1 | 
		boost::asio::ssl::context::no_tlsv1_1 | 
		boost::asio::ssl::context::no_sslv3);
}

void TestProperConfiguration_inter_IncorrectUsage01()
{
	boost::asio::ssl::context ctx(boost::asio::ssl::context::sslv23);	// BUG - missing disable SSLv3
	SetOptionsNoOldTls(ctx);
}

void TestProperConfiguration_IncorrectUsage01()
{
	boost::asio::ssl::context ctx(boost::asio::ssl::context::sslv23);	// BUG
}

void TestProperConfiguration_IncorrectUsage02()
{
	boost::asio::ssl::context ctx(boost::asio::ssl::context::tls);	// BUG
}

void TestProperConfiguration_IncorrectUsage03()
{
	boost::asio::ssl::context ctx(boost::asio::ssl::context::tls);	// BUG
	SetOptionsNoOldTls(ctx);
	ctx.set_options(boost::asio::ssl::context::no_tlsv1 |
		boost::asio::ssl::context::no_tlsv1_2 );			// BUG - disabling TLS 1.2
}

void TestHardcodedProtocols()
{
	//////////////////////// Banned Hardcoded algorithms 
	boost::asio::ssl::context cxt_sslv2(boost::asio::ssl::context::sslv2);			// BUG
	boost::asio::ssl::context cxt_sslv2c(boost::asio::ssl::context::sslv2_client);	// BUG
	boost::asio::ssl::context cxt_sslv2s(boost::asio::ssl::context::sslv2_server);	// BUG

	boost::asio::ssl::context cxt_sslv3(boost::asio::ssl::context::sslv3);			// BUG
	boost::asio::ssl::context cxt_sslv3c(boost::asio::ssl::context::sslv3_client);	// BUG
	boost::asio::ssl::context cxt_sslv3s(boost::asio::ssl::context::sslv3_server);	// BUG

	boost::asio::ssl::context cxt_tlsv1(boost::asio::ssl::context::tlsv1);			// BUG
	boost::asio::ssl::context cxt_tlsv1c(boost::asio::ssl::context::tlsv1_client);	// BUG
	boost::asio::ssl::context cxt_tlsv1s(boost::asio::ssl::context::tlsv1_server);	// BUG

	boost::asio::ssl::context cxt_tlsv11(boost::asio::ssl::context::tlsv11);			// BUG
	boost::asio::ssl::context cxt_tlsv11c(boost::asio::ssl::context::tlsv11_client);	// BUG
	boost::asio::ssl::context cxt_tlsv11s(boost::asio::ssl::context::tlsv11_server);	// BUG

	////////////////////// Hardcoded algorithms

	boost::asio::ssl::context cxt_tlsv12(boost::asio::ssl::context::tlsv12);
	boost::asio::ssl::context cxt_tlsv12c(boost::asio::ssl::context::tlsv12_client);
	boost::asio::ssl::context cxt_tlsv12s(boost::asio::ssl::context::tlsv12_server);

	boost::asio::ssl::context cxt_tlsv13(boost::asio::ssl::context::tlsv13);
	boost::asio::ssl::context cxt_tlsv13c(boost::asio::ssl::context::tlsv13_client);
	boost::asio::ssl::context cxt_tlsv13s(boost::asio::ssl::context::tlsv13_server);
}

void InterProceduralTest(boost::asio::ssl::context::method m)
{
	boost::asio::ssl::context cxt1(m);		// BUG - Multiple hits (sink)
}

void TestHardcodedProtocols_inter()
{
	//////////////////////// Banned Hardcoded algorithms 
	InterProceduralTest(boost::asio::ssl::context::sslv2);			// BUG
	InterProceduralTest(boost::asio::ssl::context::sslv2_client);	// BUG
	InterProceduralTest(boost::asio::ssl::context::sslv2_server);	// BUG

	InterProceduralTest(boost::asio::ssl::context::sslv3);			// BUG
	InterProceduralTest(boost::asio::ssl::context::sslv3_client);	// BUG
	InterProceduralTest(boost::asio::ssl::context::sslv3_server);	// BUG

	InterProceduralTest(boost::asio::ssl::context::tlsv1);			// BUG
	InterProceduralTest(boost::asio::ssl::context::tlsv1_client);	// BUG
	InterProceduralTest(boost::asio::ssl::context::tlsv1_server);	// BUG

	InterProceduralTest(boost::asio::ssl::context::tlsv11);			// BUG
	InterProceduralTest(boost::asio::ssl::context::tlsv11_client);	// BUG
	InterProceduralTest(boost::asio::ssl::context::tlsv11_server);	// BUG

	////////////////////// Hardcoded algorithms

	InterProceduralTest(boost::asio::ssl::context::tlsv12);
	InterProceduralTest(boost::asio::ssl::context::tlsv12_client);
	InterProceduralTest(boost::asio::ssl::context::tlsv12_server);

	InterProceduralTest(boost::asio::ssl::context::tlsv13);
	InterProceduralTest(boost::asio::ssl::context::tlsv13_client);
	InterProceduralTest(boost::asio::ssl::context::tlsv13_server);
}
