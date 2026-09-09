
// --- stub library headers ---

namespace bsl {
	typedef unsigned long size_t;
	typedef int int32_t;
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
	template<class charT, class traits = char_traits<charT> >
	class basic_string_view {
	public:
		basic_string_view();
		basic_string_view(const charT* s);
		const charT* data() const;
	};
	typedef basic_string_view<char> string_view;
	template <class T, class Allocator = allocator<T> >
	class vector {
	public:
		vector();
		const T* data() const;
		const T& operator[](size_t i) const;
		void push_back(const T& value);
	};
	template <class T> class span {
	public:
		span();
		span(T* p, size_t n);
		T* data() const;
	};
}

namespace BloombergLP {
namespace bslma {
	class Allocator {};
}
namespace bsls {
	struct Types { typedef long long Int64; };
}

namespace bdlbb {
	class Blob {};
	class BlobBufferFactory {};
	struct BlobUtil {
		static void copy(char *dstBuffer, const Blob &srcBlob, int position, int length);
		static void copy(Blob *dstBlob, int dstOffset, const char *srcBuffer, int length);
	};
}

namespace bmqa {
	class MessageProperties;
	class Message {
	public:
		Message& setData(const bdlbb::Blob* data);
		Message& setData(const char* data, bsl::size_t length);
		Message& setDataRef(const bdlbb::Blob* data);
		Message& setDataRef(const char* data, bsl::size_t length);
		Message& setPropertiesRef(const MessageProperties* properties);
		Message clone(bslma::Allocator* basicAllocator = 0) const;
		int getData(bdlbb::Blob* blob) const;
		int loadProperties(MessageProperties* buffer) const;
	};
	class MessageProperties {
	public:
		explicit MessageProperties(bslma::Allocator* basicAllocator = 0);
		MessageProperties(const MessageProperties& other, bslma::Allocator* basicAllocator = 0);
		MessageProperties& operator=(const MessageProperties& rhs);
		int setPropertyAsBool(bsl::string_view name, bool value);
		int setPropertyAsChar(bsl::string_view name, char value);
		int setPropertyAsShort(bsl::string_view name, short value);
		int setPropertyAsInt32(bsl::string_view name, bsl::int32_t value);
		int setPropertyAsInt64(bsl::string_view name, bsls::Types::Int64 value);
		int setPropertyAsString(bsl::string_view name, bsl::string_view value);
		int setPropertyAsBinary(bsl::string_view name, bsl::span<const char> value);
		int streamIn(const bdlbb::Blob& blob);
		const bdlbb::Blob& streamOut(bdlbb::BlobBufferFactory* bufferFactory) const;
		bsl::int32_t getPropertyAsInt32(bsl::string_view name) const;
		const bsl::string& getPropertyAsString(bsl::string_view name) const;
		const bsl::vector<char>& getPropertyAsBinary(bsl::string_view name) const;
		const bsl::string& getPropertyAsStringOr(bsl::string_view name, const bsl::string& value) const;
		const bsl::vector<char>& getPropertyAsBinaryOr(bsl::string_view name, const bsl::vector<char>& value) const;
	};
	class MessagePropertiesIterator {
	public:
		MessagePropertiesIterator();
		explicit MessagePropertiesIterator(const MessageProperties* properties);
		MessagePropertiesIterator& operator=(const MessagePropertiesIterator& rhs);
		bool hasNext();
		const bsl::string& name() const;
		bsl::int32_t getAsInt32() const;
		const bsl::string& getAsString() const;
		const bsl::vector<char>& getAsBinary() const;
	};
	class MessageIterator {
	public:
		bool nextMessage();
		const Message& message() const;
	};
	class MessageEvent {
	public:
		MessageIterator messageIterator() const;
	};
}
}

// --- test code ---

char *source();
void sink(char);
void sink(int);

// A received message or event is made by reinterpreting a tainted bsl::string.

void test_getData() {
	bsl::string data(source());
	BloombergLP::bmqa::Message *msg = (BloombergLP::bmqa::Message *)data.data();
	BloombergLP::bdlbb::Blob blob;
	msg->getData(&blob);
	char dst[16];
	BloombergLP::bdlbb::BlobUtil::copy(dst, blob, 0, 16);
	sink(*dst); // $ ir
}

void test_event_iterator_message_getData() {
	bsl::string data(source());
	BloombergLP::bmqa::MessageEvent *event = (BloombergLP::bmqa::MessageEvent *)data.data();
	BloombergLP::bmqa::MessageIterator it = event->messageIterator();
	while (it.nextMessage()) {
		const BloombergLP::bmqa::Message &msg = it.message();
		BloombergLP::bdlbb::Blob blob;
		msg.getData(&blob);
		char dst[16];
		BloombergLP::bdlbb::BlobUtil::copy(dst, blob, 0, 16);
		sink(*dst); // $ ir
	}
}

void test_setDataRef_getData_round_trip() {
	bsl::string s(source());
	BloombergLP::bdlbb::Blob in;
	BloombergLP::bdlbb::BlobUtil::copy(&in, 0, s.data(), s.size());
	BloombergLP::bmqa::Message msg;
	msg.setDataRef(&in);
	BloombergLP::bdlbb::Blob out;
	msg.getData(&out);
	char dst[16];
	BloombergLP::bdlbb::BlobUtil::copy(dst, out, 0, 16);
	sink(*dst); // $ ir
}

void test_setDataRef_chars_getData() {
	bsl::string s(source());
	BloombergLP::bmqa::Message msg;
	msg.setDataRef(s.data(), s.size());
	BloombergLP::bdlbb::Blob out;
	msg.getData(&out);
	char dst[16];
	BloombergLP::bdlbb::BlobUtil::copy(dst, out, 0, 16);
	sink(*dst); // $ ir
}

void test_setData_getData() {
	bsl::string s(source());
	BloombergLP::bmqa::Message msg;
	msg.setData(s.data(), s.size());
	BloombergLP::bdlbb::Blob out;
	msg.getData(&out);
	char dst[16];
	BloombergLP::bdlbb::BlobUtil::copy(dst, out, 0, 16);
	sink(*dst); // $ ir
}

void test_clone_getData() {
	bsl::string data(source());
	BloombergLP::bmqa::Message *msg = (BloombergLP::bmqa::Message *)data.data();
	BloombergLP::bmqa::Message copy = msg->clone();
	BloombergLP::bdlbb::Blob blob;
	copy.getData(&blob);
	char dst[16];
	BloombergLP::bdlbb::BlobUtil::copy(dst, blob, 0, 16);
	sink(*dst); // $ ir
}

void test_loadProperties_getPropertyAsString() {
	bsl::string data(source());
	BloombergLP::bmqa::Message *msg = (BloombergLP::bmqa::Message *)data.data();
	BloombergLP::bmqa::MessageProperties props;
	msg->loadProperties(&props);
	const bsl::string &value = props.getPropertyAsString("key");
	sink(value.data()[0]); // $ ir
}

void test_loadProperties_getPropertyAsBinary() {
	bsl::string data(source());
	BloombergLP::bmqa::Message *msg = (BloombergLP::bmqa::Message *)data.data();
	BloombergLP::bmqa::MessageProperties props;
	msg->loadProperties(&props);
	const bsl::vector<char> &value = props.getPropertyAsBinary("key");
	sink(value.data()[0]); // $ ir
}

void test_loadProperties_getPropertyAsBinary_index() {
	bsl::string data(source());
	BloombergLP::bmqa::Message *msg = (BloombergLP::bmqa::Message *)data.data();
	BloombergLP::bmqa::MessageProperties props;
	msg->loadProperties(&props);
	const bsl::vector<char> &value = props.getPropertyAsBinary("key");
	sink(value[0]); // $ ir
}

void test_getPropertyAsStringOr() {
	bsl::string data(source());
	BloombergLP::bmqa::Message *msg = (BloombergLP::bmqa::Message *)data.data();
	BloombergLP::bmqa::MessageProperties props;
	msg->loadProperties(&props);
	bsl::string dflt;
	const bsl::string &value = props.getPropertyAsStringOr("key", dflt);
	sink(*value.data()); // $ ir
}

// The default value is returned when the property is absent.
void test_getPropertyAsStringOr_default() {
	bsl::string dflt(source());
	BloombergLP::bmqa::MessageProperties props;
	const bsl::string &value = props.getPropertyAsStringOr("key", dflt);
	sink(*value.data()); // $ ir
}

void test_getPropertyAsBinaryOr() {
	bsl::string data(source());
	BloombergLP::bmqa::Message *msg = (BloombergLP::bmqa::Message *)data.data();
	BloombergLP::bmqa::MessageProperties props;
	msg->loadProperties(&props);
	bsl::vector<char> dflt;
	const bsl::vector<char> &value = props.getPropertyAsBinaryOr("key", dflt);
	sink(*value.data()); // $ ir
}

void test_getPropertyAsBinaryOr_default() {
	char c = *source();
	bsl::vector<char> dflt;
	dflt.push_back(c);
	BloombergLP::bmqa::MessageProperties props;
	const bsl::vector<char> &value = props.getPropertyAsBinaryOr("key", dflt);
	sink(*value.data()); // $ ir
}

void test_getPropertyAsInt32_no_flow() {
	bsl::string data(source());
	BloombergLP::bmqa::Message *msg = (BloombergLP::bmqa::Message *)data.data();
	BloombergLP::bmqa::MessageProperties props;
	msg->loadProperties(&props);
	sink(props.getPropertyAsInt32("key")); // no flow: scalar getters are not modelled
}

void test_streamIn_getPropertyAsString() {
	bsl::string s(source());
	BloombergLP::bdlbb::Blob blob;
	BloombergLP::bdlbb::BlobUtil::copy(&blob, 0, s.data(), s.size());
	BloombergLP::bmqa::MessageProperties props;
	props.streamIn(blob);
	sink(*props.getPropertyAsString("key").data()); // $ ir
}

void test_setPropertiesRef_loadProperties() {
	bsl::string s(source());
	BloombergLP::bdlbb::Blob blob;
	BloombergLP::bdlbb::BlobUtil::copy(&blob, 0, s.data(), s.size());
	BloombergLP::bmqa::MessageProperties in;
	in.streamIn(blob);
	BloombergLP::bmqa::Message msg;
	msg.setPropertiesRef(&in);
	BloombergLP::bmqa::MessageProperties out;
	msg.loadProperties(&out);
	sink(*out.getPropertyAsString("key").data()); // $ ir
}

void test_streamOut() {
	bsl::string data(source());
	BloombergLP::bmqa::Message *msg = (BloombergLP::bmqa::Message *)data.data();
	BloombergLP::bmqa::MessageProperties props;
	msg->loadProperties(&props);
	BloombergLP::bdlbb::BlobBufferFactory factory;
	const BloombergLP::bdlbb::Blob &blob = props.streamOut(&factory);
	char dst[16];
	BloombergLP::bdlbb::BlobUtil::copy(dst, blob, 0, 16);
	sink(*dst); // $ ir
}

void test_copy_constructor() {
	bsl::string data(source());
	BloombergLP::bmqa::Message *msg = (BloombergLP::bmqa::Message *)data.data();
	BloombergLP::bmqa::MessageProperties props;
	msg->loadProperties(&props);
	BloombergLP::bmqa::MessageProperties copy(props);
	sink(*copy.getPropertyAsString("key").data()); // $ ir
}

void test_assignment() {
	bsl::string data(source());
	BloombergLP::bmqa::Message *msg = (BloombergLP::bmqa::Message *)data.data();
	BloombergLP::bmqa::MessageProperties props;
	msg->loadProperties(&props);
	BloombergLP::bmqa::MessageProperties copy;
	copy = props;
	sink(*copy.getPropertyAsString("key").data()); // $ ir
}

void test_assignment_result() {
	bsl::string data(source());
	BloombergLP::bmqa::Message *msg = (BloombergLP::bmqa::Message *)data.data();
	BloombergLP::bmqa::MessageProperties props;
	msg->loadProperties(&props);
	BloombergLP::bmqa::MessageProperties copy;
	sink(*(copy = props).getPropertyAsString("key").data()); // $ ir
}

void test_setPropertyAsString() {
	bsl::string data(source());
	bsl::string_view *value = (bsl::string_view *)data.data();
	BloombergLP::bmqa::MessageProperties props;
	props.setPropertyAsString("key", *value);
	sink(*props.getPropertyAsString("key").data()); // $ ir
}

void test_setPropertyAsString_from_chars() {
	bsl::string_view value(source());
	BloombergLP::bmqa::MessageProperties props;
	props.setPropertyAsString("key", value);
	sink(*props.getPropertyAsString("key").data()); // $ ir
}

void test_setPropertyAsBinary() {
	bsl::string data(source());
	bsl::span<const char> *value = (bsl::span<const char> *)data.data();
	BloombergLP::bmqa::MessageProperties props;
	props.setPropertyAsBinary("key", *value);
	sink(*props.getPropertyAsBinary("key").data()); // $ ir
}

// A stored property name is exposed again by the iterator.
void test_setPropertyAsBool_name() {
	bsl::string_view name(source());
	BloombergLP::bmqa::MessageProperties props;
	props.setPropertyAsBool(name, true);
	BloombergLP::bmqa::MessagePropertiesIterator it(&props);
	sink(*it.name().data()); // $ ir
}

void test_setPropertyAsChar_name() {
	bsl::string_view name(source());
	BloombergLP::bmqa::MessageProperties props;
	props.setPropertyAsChar(name, 'c');
	BloombergLP::bmqa::MessagePropertiesIterator it(&props);
	sink(*it.name().data()); // $ ir
}

void test_setPropertyAsShort_name() {
	bsl::string_view name(source());
	BloombergLP::bmqa::MessageProperties props;
	props.setPropertyAsShort(name, 1);
	BloombergLP::bmqa::MessagePropertiesIterator it(&props);
	sink(*it.name().data()); // $ ir
}

void test_setPropertyAsInt32_name() {
	bsl::string_view name(source());
	BloombergLP::bmqa::MessageProperties props;
	props.setPropertyAsInt32(name, 1);
	BloombergLP::bmqa::MessagePropertiesIterator it(&props);
	sink(*it.name().data()); // $ ir
}

void test_setPropertyAsInt64_name() {
	bsl::string_view name(source());
	BloombergLP::bmqa::MessageProperties props;
	props.setPropertyAsInt64(name, 1);
	BloombergLP::bmqa::MessagePropertiesIterator it(&props);
	sink(*it.name().data()); // $ ir
}

void test_setPropertyAsString_name() {
	bsl::string_view name(source());
	BloombergLP::bmqa::MessageProperties props;
	props.setPropertyAsString(name, "value");
	BloombergLP::bmqa::MessagePropertiesIterator it(&props);
	sink(*it.name().data()); // $ ir
}

void test_setPropertyAsBinary_name() {
	bsl::string_view name(source());
	BloombergLP::bmqa::MessageProperties props;
	props.setPropertyAsBinary(name, bsl::span<const char>());
	BloombergLP::bmqa::MessagePropertiesIterator it(&props);
	sink(*it.name().data()); // $ ir
}

void test_iterator() {
	bsl::string data(source());
	BloombergLP::bmqa::Message *msg = (BloombergLP::bmqa::Message *)data.data();
	BloombergLP::bmqa::MessageProperties props;
	msg->loadProperties(&props);
	BloombergLP::bmqa::MessagePropertiesIterator it(&props);
	while (it.hasNext()) {
		sink(*it.name().data()); // $ ir
		sink(*it.getAsString().data()); // $ ir
		sink(*it.getAsBinary().data()); // $ ir
		sink(it.getAsInt32()); // no flow: scalar getters are not modelled
	}
}

void test_iterator_assignment() {
	bsl::string data(source());
	BloombergLP::bmqa::Message *msg = (BloombergLP::bmqa::Message *)data.data();
	BloombergLP::bmqa::MessageProperties props;
	msg->loadProperties(&props);
	BloombergLP::bmqa::MessagePropertiesIterator it(&props);
	BloombergLP::bmqa::MessagePropertiesIterator copy;
	copy = it;
	sink(*copy.getAsString().data()); // $ ir
	sink(*(copy = it).name().data()); // $ ir
}
