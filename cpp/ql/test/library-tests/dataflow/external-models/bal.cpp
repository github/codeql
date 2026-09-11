
// --- stub library headers ---

namespace bsl {
	typedef unsigned long size_t;
	class streambuf {};
	class istream {};
	class ostream {};
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

namespace BloombergLP {
namespace bdlar {
	class AnyRef {};
	class AnyConstRef {};
}

namespace balber {
	class BerDecoder {
	public:
		template <typename TYPE> int decode(bsl::streambuf *streamBuf, TYPE *variable);
		template <typename TYPE> int decode(bsl::istream& stream, TYPE *variable);
		template <typename TYPE> int decodeAny(bsl::streambuf *streamBuf, TYPE *variable);
		int decodeAny(bsl::streambuf *streamBuf, bdlar::AnyRef *variable);
		template <typename TYPE> int decodeAny(bsl::istream& stream, TYPE *variable);
		int decodeAny(bsl::istream& stream, bdlar::AnyRef *variable);
	};
	class BerEncoder {
	public:
		template <typename TYPE> int encode(bsl::streambuf *streamBuf, const TYPE& value);
		template <typename TYPE> int encode(bsl::ostream& stream, const TYPE& value);
		template <typename TYPE> int encodeAny(bsl::streambuf *streamBuf, const TYPE& value);
		int encodeAny(bsl::streambuf *streamBuf, const bdlar::AnyConstRef& any);
		template <typename TYPE> int encodeAny(bsl::ostream& stream, const TYPE& value);
		int encodeAny(bsl::ostream& stream, const bdlar::AnyConstRef& any);
	};
}

namespace baljsn {
	class DecoderOptions {};
	class EncoderOptions {};
	class Decoder {
	public:
		template <class TYPE> int decode(bsl::streambuf *streamBuf, TYPE *value, const DecoderOptions& options);
		template <class TYPE> int decode(bsl::streambuf *streamBuf, TYPE *value, const DecoderOptions *options);
		template <class TYPE> int decode(bsl::istream& stream, TYPE *value, const DecoderOptions& options);
		template <class TYPE> int decode(bsl::istream& stream, TYPE *value, const DecoderOptions *options);
		template <class TYPE> int decode(bsl::streambuf *streamBuf, TYPE *value);
		template <class TYPE> int decode(bsl::istream& stream, TYPE *value);
		template <class TYPE> int decodeAny(bsl::streambuf *streamBuf, TYPE *value, const DecoderOptions& options);
		template <class TYPE> int decodeAny(bsl::streambuf *streamBuf, TYPE *value, const DecoderOptions *options = 0);
		int decodeAny(bsl::streambuf *streamBuf, bdlar::AnyRef *value, const DecoderOptions& options);
		template <class TYPE> int decodeAny(bsl::istream& stream, TYPE *value, const DecoderOptions& options);
		template <class TYPE> int decodeAny(bsl::istream& stream, TYPE *value, const DecoderOptions *options = 0);
		int decodeAny(bsl::istream& stream, bdlar::AnyRef *value, const DecoderOptions& options);
	};
	class Encoder {
	public:
		template <class TYPE> int encode(bsl::streambuf *streamBuf, const TYPE& value, const EncoderOptions& options);
		template <class TYPE> int encode(bsl::streambuf *streamBuf, const TYPE& value, const EncoderOptions *options);
		template <class TYPE> int encode(bsl::ostream& stream, const TYPE& value, const EncoderOptions& options);
		template <class TYPE> int encode(bsl::ostream& stream, const TYPE& value, const EncoderOptions *options);
		template <class TYPE> int encode(bsl::streambuf *streamBuf, const TYPE& value);
		template <class TYPE> int encode(bsl::ostream& stream, const TYPE& value);
		template <class TYPE> int encodeAny(bsl::streambuf *streamBuf, const TYPE& value, const EncoderOptions& options);
		template <class TYPE> int encodeAny(bsl::streambuf *streamBuf, const TYPE& value, const EncoderOptions *options = 0);
		int encodeAny(bsl::streambuf *streamBuf, const bdlar::AnyConstRef& any, const EncoderOptions& options);
		int encodeAny(bsl::streambuf *streamBuf, const bdlar::AnyConstRef& any, const EncoderOptions *options = 0);
		template <class TYPE> int encodeAny(bsl::ostream& stream, const TYPE& value, const EncoderOptions& options);
		template <class TYPE> int encodeAny(bsl::ostream& stream, const TYPE& value, const EncoderOptions *options = 0);
		int encodeAny(bsl::ostream& stream, const bdlar::AnyConstRef& any, const EncoderOptions& options);
		int encodeAny(bsl::ostream& stream, const bdlar::AnyConstRef& any, const EncoderOptions *options = 0);
	};
}

namespace balxml {
	class Formatter {};
	class Decoder {
	public:
		int open(bsl::istream& stream, const char *uri = 0);
		int open(bsl::streambuf *buffer, const char *uri = 0);
		int open(const char *buffer, bsl::size_t length, const char *uri = 0);
		int open(const char *filename);
		template <class TYPE> bsl::istream& decode(bsl::istream& stream, TYPE *object, const char *uri = 0);
		template <class TYPE> int decode(bsl::streambuf *buffer, TYPE *object, const char *uri = 0);
		template <class TYPE> int decode(const char *buffer, bsl::size_t length, TYPE *object, const char *uri = 0);
		template <class TYPE> int decode(const char *filename, TYPE *object);
		template <class TYPE> int decode(TYPE *object);
		template <class TYPE> bsl::istream& decodeAny(bsl::istream& stream, TYPE *object, const char *uri = 0);
		bsl::istream& decodeAny(bsl::istream& stream, bdlar::AnyRef *object, const char *uri = 0);
		template <class TYPE> int decodeAny(bsl::streambuf *buffer, TYPE *object, const char *uri = 0);
		int decodeAny(bsl::streambuf *buffer, bdlar::AnyRef *object, const char *uri = 0);
		template <class TYPE> int decodeAny(TYPE *object);
		int decodeAny(bdlar::AnyRef *object);
	};
	class Encoder {
	public:
		template <class TYPE> int encode(bsl::streambuf *buffer, const TYPE& object);
		template <class TYPE> int encodeToStream(bsl::ostream& stream, const TYPE& object);
		template <class TYPE> bsl::ostream& encode(bsl::ostream& stream, const TYPE& object);
		template <class TYPE> int encode(Formatter& formatter, const TYPE& object);
		template <class TYPE> int encodeAny(bsl::streambuf *buffer, const TYPE& object);
		int encodeAny(bsl::streambuf *buffer, const bdlar::AnyConstRef& object);
		template <class TYPE> int encodeAnyToStream(bsl::ostream& stream, const TYPE& object);
		int encodeAnyToStream(bsl::ostream& stream, const bdlar::AnyConstRef& object);
		template <class TYPE> bsl::ostream& encodeAny(bsl::ostream& stream, const TYPE& object);
		bsl::ostream& encodeAny(bsl::ostream& stream, const bdlar::AnyConstRef& object);
		template <class TYPE> int encodeAny(Formatter& formatter, const TYPE& object);
		int encodeAny(Formatter& formatter, const bdlar::AnyConstRef& object);
	};
}
}

// --- test code ---

char *source();
void sink(char);

// Stand-in for a bdlat sequence type.
struct Record {
	char name[16];
};

// A tainted stream is made by reinterpreting a tainted bsl::string, as in bslx.cpp. baljsn
// and balxml only accept bdlat sequence/choice types; the stubs do not enforce that, and
// most tests decode into a bsl::string so the result can be read back. The *_struct_* tests
// show that a decoded struct is tainted as a whole but not through its fields, because
// field accesses are not taint steps (see TaintTrackingUtil.qll).

// ===== balber (BER) =====

// Decoding a tainted stream taints the decoded object.
void test_balber_decode() {
	bsl::string data(source());
	bsl::streambuf *sb = (bsl::streambuf *)data.data();
	bsl::string out;
	BloombergLP::balber::BerDecoder decoder;
	decoder.decode(sb, &out);
	sink(*out.data()); // $ ir
}

void test_balber_decode_istream() {
	bsl::string data(source());
	bsl::istream *is = (bsl::istream *)data.data();
	bsl::string out;
	BloombergLP::balber::BerDecoder decoder;
	decoder.decode(*is, &out);
	sink(*out.data()); // $ ir
}

void test_balber_decodeAny() {
	bsl::string data(source());
	bsl::streambuf *sb = (bsl::streambuf *)data.data();
	bsl::string out;
	BloombergLP::balber::BerDecoder decoder;
	decoder.decodeAny(sb, &out);
	sink(*out.data()); // $ ir
}

// Encoding a tainted object taints the destination stream.
void test_balber_encode() {
	bsl::string obj(source());
	char buf[16];
	BloombergLP::balber::BerEncoder encoder;
	encoder.encode((bsl::streambuf *)buf, obj);
	sink(buf[0]); // $ ir
}

void test_balber_encodeAny() {
	bsl::string obj(source());
	char buf[16];
	BloombergLP::balber::BerEncoder encoder;
	encoder.encodeAny((bsl::streambuf *)buf, obj);
	sink(buf[0]); // $ ir
}

// ===== baljsn (JSON) =====

// The non-deprecated overloads take a trailing DecoderOptions/EncoderOptions.
void test_baljsn_decode_options() {
	bsl::string data(source());
	bsl::streambuf *sb = (bsl::streambuf *)data.data();
	bsl::string out;
	BloombergLP::baljsn::DecoderOptions options;
	BloombergLP::baljsn::Decoder decoder;
	decoder.decode(sb, &out, options);
	sink(*out.data()); // $ ir
}

void test_baljsn_decode_istream_options_ptr() {
	bsl::string data(source());
	bsl::istream *is = (bsl::istream *)data.data();
	bsl::string out;
	BloombergLP::baljsn::DecoderOptions options;
	BloombergLP::baljsn::Decoder decoder;
	decoder.decode(*is, &out, &options);
	sink(*out.data()); // $ ir
}

void test_baljsn_decodeAny() {
	bsl::string data(source());
	bsl::streambuf *sb = (bsl::streambuf *)data.data();
	bsl::string out;
	BloombergLP::baljsn::Decoder decoder;
	decoder.decodeAny(sb, &out);
	sink(*out.data()); // $ ir
}

void test_baljsn_encode_options() {
	bsl::string obj(source());
	char buf[16];
	BloombergLP::baljsn::EncoderOptions options;
	BloombergLP::baljsn::Encoder encoder;
	encoder.encode((bsl::streambuf *)buf, obj, options);
	sink(buf[0]); // $ ir
}

void test_baljsn_encodeAny() {
	bsl::string obj(source());
	char buf[16];
	BloombergLP::baljsn::Encoder encoder;
	encoder.encodeAny((bsl::streambuf *)buf, obj);
	sink(buf[0]); // $ ir
}

// A decoded struct carries taint as a whole: re-encoding it taints the output stream.
void test_baljsn_struct_round_trip() {
	bsl::string data(source());
	bsl::streambuf *sb = (bsl::streambuf *)data.data();
	Record rec;
	BloombergLP::baljsn::Decoder decoder;
	decoder.decode(sb, &rec);
	char buf[16];
	BloombergLP::baljsn::Encoder encoder;
	encoder.encode((bsl::streambuf *)buf, rec);
	sink(buf[0]); // $ ir
}

void test_baljsn_struct_field_no_flow() {
	bsl::string data(source());
	bsl::streambuf *sb = (bsl::streambuf *)data.data();
	Record rec;
	BloombergLP::baljsn::Decoder decoder;
	decoder.decode(sb, &rec);
	sink(rec.name[0]); // no flow: field reads from a tainted object are not taint steps
}

// ===== balxml (XML) =====

void test_balxml_decode_istream() {
	bsl::string data(source());
	bsl::istream *is = (bsl::istream *)data.data();
	bsl::string out;
	BloombergLP::balxml::Decoder decoder;
	decoder.decode(*is, &out);
	sink(*out.data()); // $ ir
}

void test_balxml_decode_istream_return() {
	bsl::string data(source());
	bsl::istream *is = (bsl::istream *)data.data();
	bsl::string out;
	BloombergLP::balxml::Decoder decoder;
	bsl::istream &r = decoder.decode(*is, &out, "uri");
	sink(*(char *)&r); // $ ir
}

void test_balxml_decode_streambuf() {
	bsl::string data(source());
	bsl::streambuf *sb = (bsl::streambuf *)data.data();
	bsl::string out;
	BloombergLP::balxml::Decoder decoder;
	decoder.decode(sb, &out);
	sink(*out.data()); // $ ir
}

void test_balxml_decode_buffer_length() {
	bsl::string data(source());
	bsl::string out;
	BloombergLP::balxml::Decoder decoder;
	decoder.decode(data.data(), data.size(), &out);
	sink(*out.data()); // $ ir
}

// decode(const char *filename, TYPE *) is not modelled.
void test_balxml_decode_filename_no_flow() {
	bsl::string filename(source());
	bsl::string out;
	BloombergLP::balxml::Decoder decoder;
	decoder.decode(filename.data(), &out);
	sink(*out.data()); // no flow: the input is a path, not data
}

// The two-step open() + decode(TYPE *) form is not modelled.
void test_balxml_open_decode_no_flow() {
	bsl::string data(source());
	bsl::streambuf *sb = (bsl::streambuf *)data.data();
	bsl::string out;
	BloombergLP::balxml::Decoder decoder;
	decoder.open(sb);
	decoder.decode(&out);
	sink(*out.data()); // no flow: not modelled
}

void test_balxml_decodeAny_istream() {
	bsl::string data(source());
	bsl::istream *is = (bsl::istream *)data.data();
	bsl::string out;
	BloombergLP::balxml::Decoder decoder;
	decoder.decodeAny(*is, &out);
	sink(*out.data()); // $ ir
}

void test_balxml_decodeAny_istream_return() {
	bsl::string data(source());
	bsl::istream *is = (bsl::istream *)data.data();
	bsl::string out;
	BloombergLP::balxml::Decoder decoder;
	bsl::istream &r = decoder.decodeAny(*is, &out);
	sink(*(char *)&r); // $ ir
}

void test_balxml_decodeAny_streambuf() {
	bsl::string data(source());
	bsl::streambuf *sb = (bsl::streambuf *)data.data();
	bsl::string out;
	BloombergLP::balxml::Decoder decoder;
	decoder.decodeAny(sb, &out);
	sink(*out.data()); // $ ir
}

void test_balxml_decodeAny_AnyRef_istream() {
	bsl::string data(source());
	bsl::istream *is = (bsl::istream *)data.data();
	BloombergLP::bdlar::AnyRef any;
	BloombergLP::balxml::Decoder decoder;
	decoder.decodeAny(*is, &any);
	sink(*(char *)&any); // $ ir
}

void test_balxml_decodeAny_AnyRef_istream_return() {
	bsl::string data(source());
	bsl::istream *is = (bsl::istream *)data.data();
	BloombergLP::bdlar::AnyRef any;
	BloombergLP::balxml::Decoder decoder;
	bsl::istream &r = decoder.decodeAny(*is, &any);
	sink(*(char *)&r); // $ ir
}

void test_balxml_decodeAny_AnyRef_streambuf() {
	bsl::string data(source());
	bsl::streambuf *sb = (bsl::streambuf *)data.data();
	BloombergLP::bdlar::AnyRef any;
	BloombergLP::balxml::Decoder decoder;
	decoder.decodeAny(sb, &any);
	sink(*(char *)&any); // $ ir
}

void test_balxml_encode_streambuf() {
	bsl::string obj(source());
	char buf[16];
	BloombergLP::balxml::Encoder encoder;
	encoder.encode((bsl::streambuf *)buf, obj);
	sink(buf[0]); // $ ir
}

void test_balxml_encode_ostream() {
	bsl::string obj(source());
	char buf[16];
	BloombergLP::balxml::Encoder encoder;
	encoder.encode(*(bsl::ostream *)buf, obj);
	sink(buf[0]); // $ ir
}

void test_balxml_encode_ostream_return_from_object() {
	bsl::string obj(source());
	char buf[16];
	BloombergLP::balxml::Encoder encoder;
	bsl::ostream &r = encoder.encode(*(bsl::ostream *)buf, obj);
	sink(*(char *)&r); // $ ir
}

void test_balxml_encode_ostream_return_from_stream() {
	bsl::string data(source());
	bsl::ostream *os = (bsl::ostream *)data.data();
	bsl::string obj;
	BloombergLP::balxml::Encoder encoder;
	bsl::ostream &r = encoder.encode(*os, obj);
	sink(*(char *)&r); // $ ir
}

void test_balxml_encodeToStream() {
	bsl::string obj(source());
	char buf[16];
	BloombergLP::balxml::Encoder encoder;
	encoder.encodeToStream(*(bsl::ostream *)buf, obj);
	sink(buf[0]); // $ ir
}

// encode(Formatter &, const TYPE &) is not modelled.
void test_balxml_encode_formatter_no_flow() {
	bsl::string obj(source());
	char buf[16];
	BloombergLP::balxml::Formatter *formatter = (BloombergLP::balxml::Formatter *)buf;
	BloombergLP::balxml::Encoder encoder;
	encoder.encode(*formatter, obj);
	sink(buf[0]); // no flow: not modelled
}

void test_balxml_encodeAny_streambuf() {
	bsl::string obj(source());
	char buf[16];
	BloombergLP::balxml::Encoder encoder;
	encoder.encodeAny((bsl::streambuf *)buf, obj);
	sink(buf[0]); // $ ir
}

void test_balxml_encodeAny_ostream() {
	bsl::string obj(source());
	char buf[16];
	BloombergLP::balxml::Encoder encoder;
	encoder.encodeAny(*(bsl::ostream *)buf, obj);
	sink(buf[0]); // $ ir
}

void test_balxml_encodeAny_ostream_return_from_object() {
	bsl::string obj(source());
	char buf[16];
	BloombergLP::balxml::Encoder encoder;
	bsl::ostream &r = encoder.encodeAny(*(bsl::ostream *)buf, obj);
	sink(*(char *)&r); // $ ir
}

void test_balxml_encodeAnyToStream() {
	bsl::string obj(source());
	char buf[16];
	BloombergLP::balxml::Encoder encoder;
	encoder.encodeAnyToStream(*(bsl::ostream *)buf, obj);
	sink(buf[0]); // $ ir
}

void test_balxml_encodeAny_AnyConstRef_streambuf() {
	bsl::string data(source());
	BloombergLP::bdlar::AnyConstRef *any = (BloombergLP::bdlar::AnyConstRef *)data.data();
	char buf[16];
	BloombergLP::balxml::Encoder encoder;
	encoder.encodeAny((bsl::streambuf *)buf, *any);
	sink(buf[0]); // $ ir
}

void test_balxml_encodeAny_AnyConstRef_ostream() {
	bsl::string data(source());
	BloombergLP::bdlar::AnyConstRef *any = (BloombergLP::bdlar::AnyConstRef *)data.data();
	char buf[16];
	BloombergLP::balxml::Encoder encoder;
	encoder.encodeAny(*(bsl::ostream *)buf, *any);
	sink(buf[0]); // $ ir
}

void test_balxml_encodeAny_AnyConstRef_ostream_return_from_object() {
	bsl::string data(source());
	BloombergLP::bdlar::AnyConstRef *any = (BloombergLP::bdlar::AnyConstRef *)data.data();
	char buf[16];
	BloombergLP::balxml::Encoder encoder;
	bsl::ostream &r = encoder.encodeAny(*(bsl::ostream *)buf, *any);
	sink(*(char *)&r); // $ ir
}
