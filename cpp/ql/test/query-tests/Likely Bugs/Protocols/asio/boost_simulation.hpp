
#define SSL_OP_ALL 0x80000BFFU
#define SSL_OP_NO_SSLv2 0
#define SSL_OP_NO_SSLv3 0x02000000U
#define SSL_OP_NO_TLSv1 0x04000000U
#define SSL_OP_NO_TLSv1_1 0x10000000U
#define SSL_OP_NO_TLSv1_2 0x08000000U
#define SSL_OP_NO_TLSv1_3 0x20000000U

namespace boost {
	namespace asio {
		namespace ssl {

			class context
			{
			public:
				/// Different methods supported by a context.
				enum method
				{
					/// Generic SSL version 2.
					sslv2,

					/// SSL version 2 client.
					sslv2_client,

					/// SSL version 2 server.
					sslv2_server,

					/// Generic SSL version 3.
					sslv3,

					/// SSL version 3 client.
					sslv3_client,

					/// SSL version 3 server.
					sslv3_server,

					/// Generic TLS version 1.
					tlsv1,

					/// TLS version 1 client.
					tlsv1_client,

					/// TLS version 1 server.
					tlsv1_server,

					/// Generic SSL/TLS.
					sslv23,

					/// SSL/TLS client.
					sslv23_client,

					/// SSL/TLS server.
					sslv23_server,

					/// Generic TLS version 1.1.
					tlsv11,

					/// TLS version 1.1 client.
					tlsv11_client,

					/// TLS version 1.1 server.
					tlsv11_server,

					/// Generic TLS version 1.2.
					tlsv12,

					/// TLS version 1.2 client.
					tlsv12_client,

					/// TLS version 1.2 server.
					tlsv12_server,

					/// Generic TLS version 1.3.
					tlsv13,

					/// TLS version 1.3 client.
					tlsv13_client,

					/// TLS version 1.3 server.
					tlsv13_server,

					/// Generic TLS.
					tls,

					/// TLS client.
					tls_client,

					/// TLS server.
					tls_server
				};

				/// Bitmask type for SSL options.
				typedef long options;

				static const long default_workarounds = SSL_OP_ALL;
				static const long no_sslv2 = SSL_OP_NO_SSLv2;
				static const long no_sslv3 = SSL_OP_NO_SSLv3;
				static const long no_tlsv1 = SSL_OP_NO_TLSv1;
				static const long no_tlsv1_1 = SSL_OP_NO_TLSv1_1;
				static const long no_tlsv1_2 = SSL_OP_NO_TLSv1_2;
				static const long no_tlsv1_3 = SSL_OP_NO_TLSv1_3;

				/// Constructor.
				explicit context(method m) {}

				void context::set_options(context::options o) {}

			};
		}
	}
}