
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

namespace google {
namespace protobuf {
	// A faithful subset of `MessageLite`; every method below is declared on `MessageLite`
	// in the real headers (message_lite.h), including the iostream-based ones.
	class MessageLite {
	public:
		bool ParseFromString(const std::string &data);
		bool MergeFromString(const std::string &data);
		bool ParsePartialFromString(const std::string &data);
		bool ParseFromArray(const void *data, int size);
		bool ParseFromIstream(std::istream *input);
		bool SerializeToString(std::string *output) const;
		bool SerializePartialToString(std::string *output) const;
		bool AppendToString(std::string *output) const;
		bool SerializeToArray(void *data, int size) const;
		bool SerializeToOstream(std::ostream *output) const;
		std::string SerializeAsString() const;
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

// Message taint is observed through `SerializeToArray`, whose scalar output flows cleanly
// to a sink. The object-typed serialize outputs (String/Ostream/...) and the input-stream
// parse methods are checked directly by `steps.ql`, which asserts each summary step exists.

// Deserialization: the encoded input taints the message (`this`).
void test_ParseFromString() {
	Person msg;
	std::string data = std::string(source());
	msg.ParseFromString(data);
	char buf[64];
	msg.SerializeToArray(buf, sizeof(buf));
	sink(*buf); // $ ir
}

void test_ParseFromArray() {
	Person msg;
	std::string data = std::string(source());
	msg.ParseFromArray(data.data(), data.size());
	char buf[64];
	msg.SerializeToArray(buf, sizeof(buf));
	sink(*buf); // $ ir
}

// Serialization returning the bytes: the message taints the returned string, observed by
// parsing it into a second message and serializing that back out.
void test_SerializeAsString() {
	Person msg;
	std::string data = std::string(source());
	msg.ParseFromString(data);
	Person msg2;
	msg2.ParseFromString(msg.SerializeAsString());
	char buf[64];
	msg2.SerializeToArray(buf, sizeof(buf));
	sink(*buf); // $ ir
}

// Additional modeled methods, exercised so their summary steps are covered by `steps.ql`.
void test_step_coverage() {
	Person msg;
	std::string data = std::string(source());

	msg.MergeFromString(data);
	msg.ParsePartialFromString(data);

	std::istream in;
	msg.ParseFromIstream(&in);

	std::string out;
	msg.SerializeToString(&out);
	msg.SerializePartialToString(&out);
	msg.AppendToString(&out);

	std::ostream os;
	msg.SerializeToOstream(&os);
}
