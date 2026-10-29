
// --- stub library headers ---

#include "std_string.h"

#define SIZE_MAX 0xFFFFFFFF

namespace std {
	class string_view {
	public:
		string_view(const char* s);
	};
};

namespace boost {
	namespace system {
		class error_code {
		public:
			operator bool() const;
		};
	};
	
	namespace asio {
		class any_io_executor { };

		class socket_base { };

		template <typename Protocol, typename Executor>
		class basic_socket : public socket_base { };

		template<typename Protocol, typename Executor = any_io_executor>
		class basic_stream_socket : public basic_socket<Protocol, Executor> { };

		namespace ip {
			class resolver_base {
			public:
				enum flags { passive = 1 };
			};

			template<typename InternetProtocol, typename Executor = any_io_executor>
			class basic_resolver {
			public:
				class results_type {
				};

				results_type resolve(const std::string &host, const std::string &service);
				results_type resolve(const std::string &host, const std::string &service, boost::system::error_code &ec);
				results_type resolve(const std::string &host, const std::string &service, resolver_base::flags resolve_flags);
				results_type resolve(const std::string &host, const std::string &service, resolver_base::flags resolve_flags, boost::system::error_code &ec);
				results_type resolve(std::string_view host, std::string_view service);
				results_type resolve(std::string_view host, std::string_view service, boost::system::error_code &ec);
				results_type resolve(std::string_view host, std::string_view service, resolver_base::flags resolve_flags);
				results_type resolve(std::string_view host, std::string_view service, resolver_base::flags resolve_flags, boost::system::error_code &ec);
				results_type resolve(const InternetProtocol &protocol, const std::string &host, const std::string &service);
				results_type resolve(const InternetProtocol &protocol, const std::string &host, const std::string &service, boost::system::error_code &ec);
				results_type resolve(const InternetProtocol &protocol, const std::string &host, const std::string &service, resolver_base::flags resolve_flags);
				results_type resolve(const InternetProtocol &protocol, const std::string &host, const std::string &service, resolver_base::flags resolve_flags, boost::system::error_code &ec);
				results_type resolve(const InternetProtocol &protocol, std::string_view host, std::string_view service);
				results_type resolve(const InternetProtocol &protocol, std::string_view host, std::string_view service, boost::system::error_code &ec);
				results_type resolve(const InternetProtocol &protocol, std::string_view host, std::string_view service, resolver_base::flags resolve_flags);
				results_type resolve(const InternetProtocol &protocol, std::string_view host, std::string_view service, resolver_base::flags resolve_flags, boost::system::error_code &ec);
			};

			class tcp {
			public:
				typedef basic_stream_socket<tcp> socket;
				typedef basic_resolver<tcp> resolver;
			};
		};

		template<typename Allocator = std::allocator<char>> class basic_streambuf {
		public:
			basic_streambuf(
				std::size_t maximum_size = SIZE_MAX,
				const Allocator &allocator = Allocator());
		};

		typedef basic_streambuf<> streambuf;

		class mutable_buffer {
		};

		template<typename Elem, typename Traits, typename Allocator>
		mutable_buffer buffer(std::basic_string<Elem, Traits, Allocator> & data);

		template<typename SyncReadStream, typename Allocator> std::size_t read_until(
			SyncReadStream &s,
			asio::basic_streambuf<Allocator> &b,
			char delim,
			boost::system::error_code &ec);

		template<typename SyncWriteStream, typename ConstBufferSequence> std::size_t write(
			SyncWriteStream &s,
			const ConstBufferSequence &buffers,
			boost::system::error_code &ec,
			int constraint = 0); // simplified
	};
};

// --- test code ---

char *source();
void sink(char *);
void sink(std::string);
void sink(boost::asio::streambuf);
void sink(boost::asio::mutable_buffer);
void sink(boost::asio::ip::tcp::resolver::results_type);

char *getenv(const char *name);
int send(int, const void*, int, int);

void test(boost::asio::ip::tcp::socket &socket) {
	boost::asio::streambuf recv_buffer;
	boost::system::error_code error;

	boost::asio::read_until(socket, recv_buffer, '\0', error);
	if (error) {
		// ...
	}
	sink(recv_buffer); // $ ir

	boost::asio::write(socket, recv_buffer, error); // $ ir

	// ---

	std::string send_str = std::string(source());
	sink(send_str); // $ ir

	boost::asio::mutable_buffer send_buffer = boost::asio::buffer(send_str);
	sink(send_buffer); // $ ir

	boost::asio::write(socket, send_buffer, error); // $ ir
	if (error) {
		// ...
	}
}

void test_resolve_host() {
	boost::asio::ip::tcp::resolver resolver;
	boost::asio::ip::tcp protocol;
	boost::asio::ip::resolver_base::flags flags = boost::asio::ip::resolver_base::passive;
	boost::system::error_code error;
	std::string host(source());
	std::string service("");
	std::string_view host_view(source());
	std::string_view service_view("");

	sink(resolver.resolve(host, service)); // $ ir
	sink(resolver.resolve(host, service, error)); // $ ir
	sink(resolver.resolve(host, service, flags)); // $ ir
	sink(resolver.resolve(host, service, flags, error)); // $ ir

	sink(resolver.resolve(host_view, service_view)); // $ ir
	sink(resolver.resolve(host_view, service_view, error)); // $ ir
	sink(resolver.resolve(host_view, service_view, flags)); // $ ir
	sink(resolver.resolve(host_view, service_view, flags, error)); // $ ir

	sink(resolver.resolve(protocol, host, service)); // $ ir
	sink(resolver.resolve(protocol, host, service, error)); // $ ir
	sink(resolver.resolve(protocol, host, service, flags)); // $ ir
	sink(resolver.resolve(protocol, host, service, flags, error)); // $ ir

	sink(resolver.resolve(protocol, host_view, service_view)); // $ ir
	sink(resolver.resolve(protocol, host_view, service_view, error)); // $ ir
	sink(resolver.resolve(protocol, host_view, service_view, flags)); // $ ir
	sink(resolver.resolve(protocol, host_view, service_view, flags, error)); // $ ir
}

void test_resolve_service() {
	boost::asio::ip::tcp::resolver resolver;
	boost::asio::ip::tcp protocol;
	boost::asio::ip::resolver_base::flags flags = boost::asio::ip::resolver_base::passive;
	boost::system::error_code error;
	std::string host("");
	std::string service(source());
	std::string_view host_view("");
	std::string_view service_view(source());

	sink(resolver.resolve(host, service)); // $ ir
	sink(resolver.resolve(host, service, error)); // $ ir
	sink(resolver.resolve(host, service, flags)); // $ ir
	sink(resolver.resolve(host, service, flags, error)); // $ ir

	sink(resolver.resolve(host_view, service_view)); // $ ir
	sink(resolver.resolve(host_view, service_view, error)); // $ ir
	sink(resolver.resolve(host_view, service_view, flags)); // $ ir
	sink(resolver.resolve(host_view, service_view, flags, error)); // $ ir

	sink(resolver.resolve(protocol, host, service)); // $ ir
	sink(resolver.resolve(protocol, host, service, error)); // $ ir
	sink(resolver.resolve(protocol, host, service, flags)); // $ ir
	sink(resolver.resolve(protocol, host, service, flags, error)); // $ ir

	sink(resolver.resolve(protocol, host_view, service_view)); // $ ir
	sink(resolver.resolve(protocol, host_view, service_view, error)); // $ ir
	sink(resolver.resolve(protocol, host_view, service_view, flags)); // $ ir
	sink(resolver.resolve(protocol, host_view, service_view, flags, error)); // $ ir
}
