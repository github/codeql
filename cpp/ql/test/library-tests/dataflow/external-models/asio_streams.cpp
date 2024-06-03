
// --- stub library headers ---

namespace std {
	typedef unsigned long size_t;
	#define SIZE_MAX 0xFFFFFFFF

	template <class T> class allocator {
	};

	template<class charT> struct char_traits {
	};

	template<class charT, class traits = char_traits<charT>, class Allocator = allocator<charT> >
	class basic_string {
	public:
		basic_string(const charT* s, const Allocator& a = Allocator());
	};

	typedef basic_string<char> string;
};

namespace boost {
	namespace system {
		class error_code {
		public:
			operator bool() const;
		};
	};
	
	namespace asio {
		template<typename Protocol/*, typename Executor*/>
		class basic_stream_socket /*: public basic_socket<Protocol, Executor>*/ {
		};

		namespace ip {
			class tcp {
			public:
				typedef basic_stream_socket<tcp> socket;
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
