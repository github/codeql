
// --- stub library headers ---

namespace bsl {
	typedef unsigned long size_t;
	template <class T> class allocator {};
	template<class charT> struct char_traits {};
	template<class charT, class traits = char_traits<charT>, class Allocator = allocator<charT> >
	class basic_string {
	public:
		basic_string(const charT* s, const Allocator& a = Allocator());
		const charT* data() const;
		size_t size() const;
	};
	typedef basic_string<char> string;
	template <class T> class shared_ptr {
	public:
		T *get() const;
	};
}

namespace BloombergLP {
namespace bdlbb {
	class BlobBuffer {
	public:
		char *data() const;
		bsl::shared_ptr<char> &buffer();
		const bsl::shared_ptr<char> &buffer() const;
	};

	class Blob {
	public:
		const BlobBuffer &buffer(int index) const;
	};

	struct BlobUtil {
		static void copy(char *dstBuffer, const Blob &srcBlob, int position, int length);
		static void copy(Blob *dstBlob, int dstOffset, const char *srcBuffer, int length);
		static void copy(Blob *dstBlob, int dstOffset, const Blob &srcBlob, int srcOffset,
		                 int length);
		static char *getContiguousRangeOrCopy(char *dstBuffer, const Blob &srcBlob, int position,
		                                      int length, int alignment);
	};
}
}

// --- test code ---

char *source();
void sink(char);

// A blob populated from a tainted buffer taints the bytes read back out of it.
void test_BlobUtil_copy() {
	bsl::string s(source());
	BloombergLP::bdlbb::Blob blob;
	BloombergLP::bdlbb::BlobUtil::copy(&blob, 0, s.data(), s.size());
	char dst[16];
	BloombergLP::bdlbb::BlobUtil::copy(dst, blob, 0, 16);
	sink(*dst); // $ ir
}

void test_accessor_chain() {
	bsl::string s(source());
	BloombergLP::bdlbb::Blob blob;
	BloombergLP::bdlbb::BlobUtil::copy(&blob, 0, s.data(), s.size());
	const char *p = blob.buffer(0).data();
	sink(*p); // $ ir
}

// The get() step comes from the built-in smart pointer model, not from bdlbb.model.yml.
void test_accessor_chain_shared_ptr() {
	bsl::string s(source());
	BloombergLP::bdlbb::Blob blob;
	BloombergLP::bdlbb::BlobUtil::copy(&blob, 0, s.data(), s.size());
	const char *p = blob.buffer(0).buffer().get();
	sink(*p); // $ ir
}

void test_getContiguousRangeOrCopy() {
	bsl::string s(source());
	BloombergLP::bdlbb::Blob blob;
	BloombergLP::bdlbb::BlobUtil::copy(&blob, 0, s.data(), s.size());
	char dst[16];
	char *r = BloombergLP::bdlbb::BlobUtil::getContiguousRangeOrCopy(dst, blob, 0, 16, 1);
	sink(*r); // $ ir
}

// A blob copied into another blob carries the taint across.
void test_BlobUtil_copy_blob_to_blob() {
	bsl::string s(source());
	BloombergLP::bdlbb::Blob src;
	BloombergLP::bdlbb::BlobUtil::copy(&src, 0, s.data(), s.size());
	BloombergLP::bdlbb::Blob dst;
	BloombergLP::bdlbb::BlobUtil::copy(&dst, 0, src, 0, 16);
	char out[16];
	BloombergLP::bdlbb::BlobUtil::copy(out, dst, 0, 16);
	sink(*out); // $ ir
}
