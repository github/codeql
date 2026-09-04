
// --- stub library headers ---

namespace std {
	typedef unsigned long size_t;
	template <class T> class allocator {};
	template<class charT> struct char_traits {};
	template<class charT, class traits = char_traits<charT>, class Allocator = allocator<charT> >
	class basic_string {
	public:
		basic_string();
		basic_string(const charT* s, const Allocator& a = Allocator());
		const charT* data() const;
		size_t size() const;
	};
	typedef basic_string<char> string;
}

// BDE spells the standard string as `bsl::string`; alias it onto the stub above.
namespace bsl {
	using std::string;
}

// BDE wraps every package-group namespace in `BloombergLP`; this stub reproduces that.
namespace BloombergLP {
namespace bsls {
	// `bsls::Types` provides the fixed-width integer aliases used by the stream API.
	struct Types {
		typedef long long Int64;
		typedef unsigned long long Uint64;
	};
}
namespace bslx {
	class ByteInStream {
	public:
		ByteInStream();
		ByteInStream(const char *buffer, std::size_t numBytes);
		void reset(const char *buffer, std::size_t numBytes);
		ByteInStream &getLength(int &variable);
		ByteInStream &getVersion(int &variable);
		ByteInStream &getInt8(char &variable);
		ByteInStream &getUint8(unsigned char &variable);
		ByteInStream &getInt16(short &variable);
		ByteInStream &getUint16(unsigned short &variable);
		ByteInStream &getInt24(int &variable);
		ByteInStream &getUint24(unsigned int &variable);
		ByteInStream &getInt32(int &variable);
		ByteInStream &getUint32(unsigned int &variable);
		ByteInStream &getInt40(bsls::Types::Int64 &variable);
		ByteInStream &getUint40(bsls::Types::Uint64 &variable);
		ByteInStream &getInt48(bsls::Types::Int64 &variable);
		ByteInStream &getUint48(bsls::Types::Uint64 &variable);
		ByteInStream &getInt56(bsls::Types::Int64 &variable);
		ByteInStream &getUint56(bsls::Types::Uint64 &variable);
		ByteInStream &getInt64(bsls::Types::Int64 &variable);
		ByteInStream &getUint64(bsls::Types::Uint64 &variable);
		ByteInStream &getFloat32(float &variable);
		ByteInStream &getFloat64(double &variable);
		ByteInStream &getString(bsl::string &variable);
		ByteInStream &getArrayInt8(char *variables, int numVariables);
		ByteInStream &getArrayUint8(unsigned char *variables, int numVariables);
		ByteInStream &getArrayInt16(short *variables, int numVariables);
		ByteInStream &getArrayUint16(unsigned short *variables, int numVariables);
		ByteInStream &getArrayInt24(int *variables, int numVariables);
		ByteInStream &getArrayUint24(unsigned int *variables, int numVariables);
		ByteInStream &getArrayInt32(int *variables, int numVariables);
		ByteInStream &getArrayUint32(unsigned int *variables, int numVariables);
		ByteInStream &getArrayInt40(bsls::Types::Int64 *variables, int numVariables);
		ByteInStream &getArrayUint40(bsls::Types::Uint64 *variables, int numVariables);
		ByteInStream &getArrayInt48(bsls::Types::Int64 *variables, int numVariables);
		ByteInStream &getArrayUint48(bsls::Types::Uint64 *variables, int numVariables);
		ByteInStream &getArrayInt56(bsls::Types::Int64 *variables, int numVariables);
		ByteInStream &getArrayUint56(bsls::Types::Uint64 *variables, int numVariables);
		ByteInStream &getArrayInt64(bsls::Types::Int64 *variables, int numVariables);
		ByteInStream &getArrayUint64(bsls::Types::Uint64 *variables, int numVariables);
		ByteInStream &getArrayFloat32(float *variables, int numVariables);
		ByteInStream &getArrayFloat64(double *variables, int numVariables);
	};

	template <class STREAMBUF>
	class GenericInStream {
	public:
		GenericInStream(STREAMBUF *streamBuf);
		GenericInStream &getLength(int &variable);
		GenericInStream &getVersion(int &variable);
		GenericInStream &getInt8(char &variable);
		GenericInStream &getUint8(unsigned char &variable);
		GenericInStream &getInt16(short &variable);
		GenericInStream &getUint16(unsigned short &variable);
		GenericInStream &getInt24(int &variable);
		GenericInStream &getUint24(unsigned int &variable);
		GenericInStream &getInt32(int &variable);
		GenericInStream &getUint32(unsigned int &variable);
		GenericInStream &getInt40(bsls::Types::Int64 &variable);
		GenericInStream &getUint40(bsls::Types::Uint64 &variable);
		GenericInStream &getInt48(bsls::Types::Int64 &variable);
		GenericInStream &getUint48(bsls::Types::Uint64 &variable);
		GenericInStream &getInt56(bsls::Types::Int64 &variable);
		GenericInStream &getUint56(bsls::Types::Uint64 &variable);
		GenericInStream &getInt64(bsls::Types::Int64 &variable);
		GenericInStream &getUint64(bsls::Types::Uint64 &variable);
		GenericInStream &getFloat32(float &variable);
		GenericInStream &getFloat64(double &variable);
		GenericInStream &getString(bsl::string &variable);
		GenericInStream &getArrayInt8(char *variables, int numVariables);
		GenericInStream &getArrayUint8(unsigned char *variables, int numVariables);
		GenericInStream &getArrayInt16(short *variables, int numVariables);
		GenericInStream &getArrayUint16(unsigned short *variables, int numVariables);
		GenericInStream &getArrayInt24(int *variables, int numVariables);
		GenericInStream &getArrayUint24(unsigned int *variables, int numVariables);
		GenericInStream &getArrayInt32(int *variables, int numVariables);
		GenericInStream &getArrayUint32(unsigned int *variables, int numVariables);
		GenericInStream &getArrayInt40(bsls::Types::Int64 *variables, int numVariables);
		GenericInStream &getArrayUint40(bsls::Types::Uint64 *variables, int numVariables);
		GenericInStream &getArrayInt48(bsls::Types::Int64 *variables, int numVariables);
		GenericInStream &getArrayUint48(bsls::Types::Uint64 *variables, int numVariables);
		GenericInStream &getArrayInt56(bsls::Types::Int64 *variables, int numVariables);
		GenericInStream &getArrayUint56(bsls::Types::Uint64 *variables, int numVariables);
		GenericInStream &getArrayInt64(bsls::Types::Int64 *variables, int numVariables);
		GenericInStream &getArrayUint64(bsls::Types::Uint64 *variables, int numVariables);
		GenericInStream &getArrayFloat32(float *variables, int numVariables);
		GenericInStream &getArrayFloat64(double *variables, int numVariables);
	};

	namespace InStreamFunctions {
		template <class STREAM, class TYPE>
		STREAM &bdexStreamIn(STREAM &stream, TYPE &variable);
	}
}
}

struct MyStreamBuf {};

char *source();
void sink(int);
void sink(char);

// --- flow tests (source -> sink) ---

void test_ByteInStream_getInt32() {
	std::string data = std::string(source());
	BloombergLP::bslx::ByteInStream stream(data.data(), data.size());
	int x = 0;
	stream.getInt32(x);
	sink(x); // $ ir
}

void test_ByteInStream_getArrayInt8() {
	std::string data = std::string(source());
	BloombergLP::bslx::ByteInStream stream(data.data(), data.size());
	char buf[16];
	stream.getArrayInt8(buf, 16);
	sink(*buf); // $ ir
}

void test_ByteInStream_getString() {
	std::string data = std::string(source());
	BloombergLP::bslx::ByteInStream stream(data.data(), data.size());
	std::string out;
	stream.getString(out);
	sink(*out.data()); // $ ir
}

void test_ByteInStream_chained() {
	std::string data = std::string(source());
	BloombergLP::bslx::ByteInStream stream(data.data(), data.size());
	int a = 0;
	int b = 0;
	stream.getInt32(a).getInt32(b);
	sink(b); // $ ir
}

void test_ByteInStream_reset() {
	BloombergLP::bslx::ByteInStream stream;
	std::string data = std::string(source());
	stream.reset(data.data(), data.size());
	int x = 0;
	stream.getInt32(x);
	sink(x); // $ ir
}

void test_GenericInStream_flow() {
	std::string data = std::string(source());
	MyStreamBuf *sb = (MyStreamBuf *)data.data();
	BloombergLP::bslx::GenericInStream<MyStreamBuf> stream(sb);
	int x = 0;
	stream.getInt32(x);
	sink(x); // $ ir
}

void test_bdexStreamIn() {
	std::string data = std::string(source());
	BloombergLP::bslx::ByteInStream stream(data.data(), data.size());
	int obj = 0;
	BloombergLP::bslx::InStreamFunctions::bdexStreamIn(stream, obj);
	sink(obj); // $ ir
}

// --- coverage: call every modeled getter so steps.ql verifies each row is consumed ---

void coverage_ByteInStream(BloombergLP::bslx::ByteInStream &stream) {
	int i = 0;
	unsigned int ui = 0;
	char c = 0;
	unsigned char uc = 0;
	short s = 0;
	unsigned short us = 0;
	BloombergLP::bsls::Types::Int64 ll = 0;
	BloombergLP::bsls::Types::Uint64 ull = 0;
	float f = 0;
	double d = 0;
	bsl::string str;
	char cbuf[16];
	unsigned char ucbuf[16];
	short sbuf[16];
	unsigned short usbuf[16];
	int ibuf[16];
	unsigned int uibuf[16];
	BloombergLP::bsls::Types::Int64 llbuf[16];
	BloombergLP::bsls::Types::Uint64 ullbuf[16];
	float fbuf[16];
	double dbuf[16];
	stream.getLength(i).getVersion(i).getInt8(c).getUint8(uc).getInt16(s).getUint16(us).getInt24(i).getUint24(ui).getInt32(i).getUint32(ui).getInt40(ll).getUint40(ull).getInt48(ll).getUint48(ull).getInt56(ll).getUint56(ull).getInt64(ll).getUint64(ull).getFloat32(f).getFloat64(d).getString(str).getArrayInt8(cbuf, 16).getArrayUint8(ucbuf, 16).getArrayInt16(sbuf, 16).getArrayUint16(usbuf, 16).getArrayInt24(ibuf, 16).getArrayUint24(uibuf, 16).getArrayInt32(ibuf, 16).getArrayUint32(uibuf, 16).getArrayInt40(llbuf, 16).getArrayUint40(ullbuf, 16).getArrayInt48(llbuf, 16).getArrayUint48(ullbuf, 16).getArrayInt56(llbuf, 16).getArrayUint56(ullbuf, 16).getArrayInt64(llbuf, 16).getArrayUint64(ullbuf, 16).getArrayFloat32(fbuf, 16).getArrayFloat64(dbuf, 16);
}

void coverage_GenericInStream(BloombergLP::bslx::GenericInStream<MyStreamBuf> &stream) {
	int i = 0;
	unsigned int ui = 0;
	char c = 0;
	unsigned char uc = 0;
	short s = 0;
	unsigned short us = 0;
	BloombergLP::bsls::Types::Int64 ll = 0;
	BloombergLP::bsls::Types::Uint64 ull = 0;
	float f = 0;
	double d = 0;
	bsl::string str;
	char cbuf[16];
	unsigned char ucbuf[16];
	short sbuf[16];
	unsigned short usbuf[16];
	int ibuf[16];
	unsigned int uibuf[16];
	BloombergLP::bsls::Types::Int64 llbuf[16];
	BloombergLP::bsls::Types::Uint64 ullbuf[16];
	float fbuf[16];
	double dbuf[16];
	stream.getLength(i).getVersion(i).getInt8(c).getUint8(uc).getInt16(s).getUint16(us).getInt24(i).getUint24(ui).getInt32(i).getUint32(ui).getInt40(ll).getUint40(ull).getInt48(ll).getUint48(ull).getInt56(ll).getUint56(ull).getInt64(ll).getUint64(ull).getFloat32(f).getFloat64(d).getString(str).getArrayInt8(cbuf, 16).getArrayUint8(ucbuf, 16).getArrayInt16(sbuf, 16).getArrayUint16(usbuf, 16).getArrayInt24(ibuf, 16).getArrayUint24(uibuf, 16).getArrayInt32(ibuf, 16).getArrayUint32(uibuf, 16).getArrayInt40(llbuf, 16).getArrayUint40(ullbuf, 16).getArrayInt48(llbuf, 16).getArrayUint48(ullbuf, 16).getArrayInt56(llbuf, 16).getArrayUint56(ullbuf, 16).getArrayInt64(llbuf, 16).getArrayUint64(ullbuf, 16).getArrayFloat32(fbuf, 16).getArrayFloat64(dbuf, 16);
}
