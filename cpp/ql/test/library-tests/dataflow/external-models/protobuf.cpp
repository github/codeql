
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

	class MessageLite {
	public:
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

		bool SerializeToString(std::string *output) const;
		bool SerializePartialToString(std::string *output) const;
		bool AppendToString(std::string *output) const;
		bool AppendPartialToString(std::string *output) const;
		bool SerializeToString(absl::Cord *output) const;
		bool SerializePartialToString(absl::Cord *output) const;
		bool AppendToString(absl::Cord *output) const;
		bool AppendPartialToString(absl::Cord *output) const;
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

template<typename T> T source();
void sink(...);

using namespace google::protobuf::io;

// Deserialization: the input taints the message.

void test_ParseFromString_string_view() {
	Person msg;
	absl::string_view data = source<absl::string_view>();
	msg.ParseFromString(data);
	sink(msg); // $ ir
}

void test_ParseFromString_Cord() {
	Person msg;
	absl::Cord data = source<absl::Cord>();
	msg.ParseFromString(data);
	sink(msg); // $ ir
}

void test_ParsePartialFromString_string_view() {
	Person msg;
	absl::string_view data = source<absl::string_view>();
	msg.ParsePartialFromString(data);
	sink(msg); // $ ir
}

void test_ParsePartialFromString_Cord() {
	Person msg;
	absl::Cord data = source<absl::Cord>();
	msg.ParsePartialFromString(data);
	sink(msg); // $ ir
}

void test_MergeFromString_string_view() {
	Person msg;
	absl::string_view data = source<absl::string_view>();
	msg.MergeFromString(data);
	sink(msg); // $ ir
}

void test_MergeFromString_Cord() {
	Person msg;
	absl::Cord data = source<absl::Cord>();
	msg.MergeFromString(data);
	sink(msg); // $ ir
}

void test_MergePartialFromString_string_view() {
	Person msg;
	absl::string_view data = source<absl::string_view>();
	msg.MergePartialFromString(data);
	sink(msg); // $ ir
}

void test_MergePartialFromString_Cord() {
	Person msg;
	absl::Cord data = source<absl::Cord>();
	msg.MergePartialFromString(data);
	sink(msg); // $ ir
}

void test_ParseFromArray() {
	Person msg;
	std::string data(source<const char *>());
	msg.ParseFromArray(data.data(), data.size());
	sink(msg); // $ ir
}

void test_ParsePartialFromArray() {
	Person msg;
	std::string data(source<const char *>());
	msg.ParsePartialFromArray(data.data(), data.size());
	sink(msg); // $ ir
}

void test_ParseFromCord() {
	Person msg;
	absl::Cord data = source<absl::Cord>();
	msg.ParseFromCord(data);
	sink(msg); // $ ir
}

void test_ParsePartialFromCord() {
	Person msg;
	absl::Cord data = source<absl::Cord>();
	msg.ParsePartialFromCord(data);
	sink(msg); // $ ir
}

void test_MergeFromCord() {
	Person msg;
	absl::Cord data = source<absl::Cord>();
	msg.MergeFromCord(data);
	sink(msg); // $ ir
}

void test_MergePartialFromCord() {
	Person msg;
	absl::Cord data = source<absl::Cord>();
	msg.MergePartialFromCord(data);
	sink(msg); // $ ir
}

void test_ParseFromIstream() {
	Person msg;
	std::istream in = source<std::istream>();
	msg.ParseFromIstream(&in);
	sink(msg); // $ ir
}

void test_ParsePartialFromIstream() {
	Person msg;
	std::istream in = source<std::istream>();
	msg.ParsePartialFromIstream(&in);
	sink(msg); // $ ir
}

void test_ParseFromZeroCopyStream() {
	Person msg;
	ZeroCopyInputStream in = source<ZeroCopyInputStream>();
	msg.ParseFromZeroCopyStream(&in);
	sink(msg); // $ ir
}

void test_ParsePartialFromZeroCopyStream() {
	Person msg;
	ZeroCopyInputStream in = source<ZeroCopyInputStream>();
	msg.ParsePartialFromZeroCopyStream(&in);
	sink(msg); // $ ir
}

void test_ParseFromBoundedZeroCopyStream() {
	Person msg;
	ZeroCopyInputStream in = source<ZeroCopyInputStream>();
	msg.ParseFromBoundedZeroCopyStream(&in, 1);
	sink(msg); // $ ir
}

void test_ParsePartialFromBoundedZeroCopyStream() {
	Person msg;
	ZeroCopyInputStream in = source<ZeroCopyInputStream>();
	msg.ParsePartialFromBoundedZeroCopyStream(&in, 1);
	sink(msg); // $ ir
}

void test_MergeFromBoundedZeroCopyStream() {
	Person msg;
	ZeroCopyInputStream in = source<ZeroCopyInputStream>();
	msg.MergeFromBoundedZeroCopyStream(&in, 1);
	sink(msg); // $ ir
}

void test_MergePartialFromBoundedZeroCopyStream() {
	Person msg;
	ZeroCopyInputStream in = source<ZeroCopyInputStream>();
	msg.MergePartialFromBoundedZeroCopyStream(&in, 1);
	sink(msg); // $ ir
}

void test_ParseFromCodedStream() {
	Person msg;
	CodedInputStream in = source<CodedInputStream>();
	msg.ParseFromCodedStream(&in);
	sink(msg); // $ ir
}

void test_ParsePartialFromCodedStream() {
	Person msg;
	CodedInputStream in = source<CodedInputStream>();
	msg.ParsePartialFromCodedStream(&in);
	sink(msg); // $ ir
}

void test_MergeFromCodedStream() {
	Person msg;
	CodedInputStream in = source<CodedInputStream>();
	msg.MergeFromCodedStream(&in);
	sink(msg); // $ ir
}

void test_MergePartialFromCodedStream() {
	Person msg;
	CodedInputStream in = source<CodedInputStream>();
	msg.MergePartialFromCodedStream(&in);
	sink(msg); // $ ir
}

void test_untainted_input() {
	Person msg;
	absl::Cord data;
	msg.ParseFromString(data);
	sink(msg); // clean
}

// Serialization: the message taints the output argument.

void test_SerializeToString() {
	Person msg = source<Person>();
	std::string out;
	msg.SerializeToString(&out);
	sink(out); // $ ir
}

void test_SerializePartialToString() {
	Person msg = source<Person>();
	std::string out;
	msg.SerializePartialToString(&out);
	sink(out); // $ ir
}

void test_AppendToString() {
	Person msg = source<Person>();
	std::string out;
	msg.AppendToString(&out);
	sink(out); // $ ir
}

void test_AppendPartialToString() {
	Person msg = source<Person>();
	std::string out;
	msg.AppendPartialToString(&out);
	sink(out); // $ ir
}

void test_SerializeToString_Cord() {
	Person msg = source<Person>();
	absl::Cord out;
	msg.SerializeToString(&out);
	sink(out); // $ ir
}

void test_SerializePartialToString_Cord() {
	Person msg = source<Person>();
	absl::Cord out;
	msg.SerializePartialToString(&out);
	sink(out); // $ ir
}

void test_AppendToString_Cord() {
	Person msg = source<Person>();
	absl::Cord out;
	msg.AppendToString(&out);
	sink(out); // $ ir
}

void test_AppendPartialToString_Cord() {
	Person msg = source<Person>();
	absl::Cord out;
	msg.AppendPartialToString(&out);
	sink(out); // $ ir
}

void test_SerializeToArray() {
	Person msg = source<Person>();
	char buf[64];
	msg.SerializeToArray(buf, sizeof(buf));
	sink(*buf); // $ ir
}

void test_SerializePartialToArray() {
	Person msg = source<Person>();
	char buf[64];
	msg.SerializePartialToArray(buf, sizeof(buf));
	sink(*buf); // $ ir
}

void test_SerializeToCord() {
	Person msg = source<Person>();
	absl::Cord out;
	msg.SerializeToCord(&out);
	sink(out); // $ ir
}

void test_SerializePartialToCord() {
	Person msg = source<Person>();
	absl::Cord out;
	msg.SerializePartialToCord(&out);
	sink(out); // $ ir
}

void test_AppendToCord() {
	Person msg = source<Person>();
	absl::Cord out;
	msg.AppendToCord(&out);
	sink(out); // $ ir
}

void test_AppendPartialToCord() {
	Person msg = source<Person>();
	absl::Cord out;
	msg.AppendPartialToCord(&out);
	sink(out); // $ ir
}

void test_SerializeToOstream() {
	Person msg = source<Person>();
	std::ostream out;
	msg.SerializeToOstream(&out);
	sink(out); // $ ir
}

void test_SerializePartialToOstream() {
	Person msg = source<Person>();
	std::ostream out;
	msg.SerializePartialToOstream(&out);
	sink(out); // $ ir
}

void test_SerializeToZeroCopyStream() {
	Person msg = source<Person>();
	ZeroCopyOutputStream out;
	msg.SerializeToZeroCopyStream(&out);
	sink(out); // $ ir
}

void test_SerializePartialToZeroCopyStream() {
	Person msg = source<Person>();
	ZeroCopyOutputStream out;
	msg.SerializePartialToZeroCopyStream(&out);
	sink(out); // $ ir
}

void test_SerializeToCodedStream() {
	Person msg = source<Person>();
	CodedOutputStream out;
	msg.SerializeToCodedStream(&out);
	sink(out); // $ ir
}

void test_SerializePartialToCodedStream() {
	Person msg = source<Person>();
	CodedOutputStream out;
	msg.SerializePartialToCodedStream(&out);
	sink(out); // $ ir
}

// Serialization: the message taints the returned bytes.

void test_SerializeAsString() {
	Person msg = source<Person>();
	sink(msg.SerializeAsString()); // $ ir
}

void test_SerializePartialAsString() {
	Person msg = source<Person>();
	sink(msg.SerializePartialAsString()); // $ ir
}

void test_SerializeAsCord() {
	Person msg = source<Person>();
	sink(msg.SerializeAsCord()); // $ ir
}

void test_SerializePartialAsCord() {
	Person msg = source<Person>();
	sink(msg.SerializePartialAsCord()); // $ ir
}

void test_untainted_message() {
	Person msg;
	sink(msg.SerializeAsString()); // clean
}
