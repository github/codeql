
// --- stub library headers ---

namespace std {
	typedef unsigned long size_t;

	template <class T> class allocator {
	};

	template<class charT> struct char_traits {
	};

	template<class charT, class traits = char_traits<charT>, class Allocator = allocator<charT> >
	class basic_string {
	public:
		basic_string();
		basic_string(const charT* s, const Allocator& a = Allocator());
		const charT* data() const;
		size_t size() const;
	};

	typedef basic_string<char> string;

	class istream {
	public:
		istream();
	};

	class ostream {
	public:
		ostream();
	};
}

namespace absl {
	// `absl::string_view` is passed by value; `absl::Cord` is passed by const reference.
	class string_view {
	public:
		string_view();
		string_view(const char *s);
		string_view(const std::string &s);
	};

	class Cord {
	public:
		Cord();
	};
}

namespace google {
namespace protobuf {
	namespace io {
		class ZeroCopyInputStream {};
		class ZeroCopyOutputStream {};
		class CodedInputStream {};
		class CodedOutputStream {};
	}

	// A faithful subset of `MessageLite`. The string/Cord/stream signatures mirror the real
	// `message_lite.h`; the iostream-based methods are declared on `Message` in the real headers
	// but are modeled here on `MessageLite` (with `subtypes` covering `Message`).
	class MessageLite {
	public:
		// Deserialization: input taints the message.
		bool ParseFromString(absl::string_view data);
		bool ParseFromString(const absl::Cord &data);
		bool ParsePartialFromString(absl::string_view data);
		bool ParsePartialFromString(const absl::Cord &data);
		bool MergeFromString(absl::string_view data);
		bool MergeFromString(const absl::Cord &data);
		bool MergePartialFromString(absl::string_view data);
		bool MergePartialFromString(const absl::Cord &data);
		bool ParseFromArray(const void *data, int size);
		bool ParsePartialFromArray(const void *data, int size);
		bool ParseFromCord(const absl::Cord &data);
		bool ParsePartialFromCord(const absl::Cord &data);
		bool MergeFromCord(const absl::Cord &data);
		bool MergePartialFromCord(const absl::Cord &data);
		bool ParseFromIstream(std::istream *input);
		bool ParsePartialFromIstream(std::istream *input);
		bool ParseFromZeroCopyStream(io::ZeroCopyInputStream *input);
		bool ParsePartialFromZeroCopyStream(io::ZeroCopyInputStream *input);
		bool ParseFromBoundedZeroCopyStream(io::ZeroCopyInputStream *input, int size);
		bool ParsePartialFromBoundedZeroCopyStream(io::ZeroCopyInputStream *input, int size);
		bool MergeFromBoundedZeroCopyStream(io::ZeroCopyInputStream *input, int size);
		bool MergePartialFromBoundedZeroCopyStream(io::ZeroCopyInputStream *input, int size);
		bool ParseFromCodedStream(io::CodedInputStream *input);
		bool ParsePartialFromCodedStream(io::CodedInputStream *input);
		bool MergeFromCodedStream(io::CodedInputStream *input);
		bool MergePartialFromCodedStream(io::CodedInputStream *input);

		// Serialization into an output buffer/stream: the message taints the output argument.
		bool SerializeToString(std::string *output) const;
		bool SerializePartialToString(std::string *output) const;
		bool AppendToString(std::string *output) const;
		bool AppendPartialToString(std::string *output) const;
		bool SerializeToArray(void *data, int size) const;
		bool SerializePartialToArray(void *data, int size) const;
		bool SerializeToCord(absl::Cord *output) const;
		bool SerializePartialToCord(absl::Cord *output) const;
		bool AppendToCord(absl::Cord *output) const;
		bool AppendPartialToCord(absl::Cord *output) const;
		bool SerializeToOstream(std::ostream *output) const;
		bool SerializePartialToOstream(std::ostream *output) const;
		bool SerializeToZeroCopyStream(io::ZeroCopyOutputStream *output) const;
		bool SerializePartialToZeroCopyStream(io::ZeroCopyOutputStream *output) const;
		bool SerializeToCodedStream(io::CodedOutputStream *output) const;
		bool SerializePartialToCodedStream(io::CodedOutputStream *output) const;

		// Serialization returning the bytes.
		std::string SerializeAsString() const;
		std::string SerializePartialAsString() const;
		absl::Cord SerializeAsCord() const;
		absl::Cord SerializePartialAsCord() const;
	};

	class Message : public MessageLite {
	};
}
}

// A generated message type derives from `Message`.
class Person : public google::protobuf::Message {
};

// --- test code ---

char *source();
void sink(char);

// End-to-end flow is demonstrated through the pointer-to-buffer methods, where content taint
// flows naturally: `ParseFromArray` reads a tainted buffer into the message, and `SerializeToArray`
// writes the message back out to a scalar buffer that reaches the sink. The `string_view`, `Cord`,
// and stream overloads do not carry content taint through their argument conversions without further
// library models, so they are exercised for summary-step coverage (`steps.ql`) rather than flow.

// Deserialization: the encoded input taints the message (`this`).
void test_ParseFromArray() {
	Person msg;
	std::string data = std::string(source());
	msg.ParseFromArray(data.data(), data.size());
	char buf[64];
	msg.SerializeToArray(buf, sizeof(buf));
	sink(*buf); // $ ir
}

// Serialization returning the bytes: the message taints the returned string, observed by parsing it
// into a second message and serializing that back out.
void test_SerializeAsString() {
	Person msg;
	std::string data = std::string(source());
	msg.ParseFromArray(data.data(), data.size());
	std::string s = msg.SerializeAsString();
	Person msg2;
	msg2.ParseFromArray(s.data(), s.size());
	char buf[64];
	msg2.SerializeToArray(buf, sizeof(buf));
	sink(*buf); // $ ir
}

// Every modeled method is called below so its summary step is covered by `steps.ql`. Endpoint
// mistakes and rows that fail to bind show up as missing lines in `steps.expected`.
void test_step_coverage() {
	Person msg;
	std::string data = std::string(source());
	absl::string_view sv = data;
	absl::Cord cord;

	msg.ParseFromString(sv);
	msg.ParseFromString(cord);
	msg.ParsePartialFromString(sv);
	msg.ParsePartialFromString(cord);
	msg.MergeFromString(sv);
	msg.MergeFromString(cord);
	msg.MergePartialFromString(sv);
	msg.MergePartialFromString(cord);

	msg.ParsePartialFromArray(data.data(), data.size());

	msg.ParseFromCord(cord);
	msg.ParsePartialFromCord(cord);
	msg.MergeFromCord(cord);
	msg.MergePartialFromCord(cord);

	std::istream in;
	msg.ParseFromIstream(&in);
	msg.ParsePartialFromIstream(&in);

	google::protobuf::io::ZeroCopyInputStream zin;
	msg.ParseFromZeroCopyStream(&zin);
	msg.ParsePartialFromZeroCopyStream(&zin);
	msg.ParseFromBoundedZeroCopyStream(&zin, 1);
	msg.ParsePartialFromBoundedZeroCopyStream(&zin, 1);
	msg.MergeFromBoundedZeroCopyStream(&zin, 1);
	msg.MergePartialFromBoundedZeroCopyStream(&zin, 1);

	google::protobuf::io::CodedInputStream cin;
	msg.ParseFromCodedStream(&cin);
	msg.ParsePartialFromCodedStream(&cin);
	msg.MergeFromCodedStream(&cin);
	msg.MergePartialFromCodedStream(&cin);

	std::string out;
	msg.SerializeToString(&out);
	msg.SerializePartialToString(&out);
	msg.AppendToString(&out);
	msg.AppendPartialToString(&out);

	char buf[64];
	msg.SerializePartialToArray(buf, sizeof(buf));

	absl::Cord cordout;
	msg.SerializeToCord(&cordout);
	msg.SerializePartialToCord(&cordout);
	msg.AppendToCord(&cordout);
	msg.AppendPartialToCord(&cordout);

	std::ostream os;
	msg.SerializeToOstream(&os);
	msg.SerializePartialToOstream(&os);

	google::protobuf::io::ZeroCopyOutputStream zout;
	msg.SerializeToZeroCopyStream(&zout);
	msg.SerializePartialToZeroCopyStream(&zout);

	google::protobuf::io::CodedOutputStream cout;
	msg.SerializeToCodedStream(&cout);
	msg.SerializePartialToCodedStream(&cout);

	msg.SerializeAsString();
	msg.SerializePartialAsString();
	msg.SerializeAsCord();
	msg.SerializePartialAsCord();
}
