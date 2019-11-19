
///// Library functions //////

typedef unsigned long size_t;

void *malloc(size_t size);
void free(void *ptr);
size_t strlen(const char *s);

namespace std
{
	template<class charT> struct char_traits;

	template <class T> class allocator {
	public:
		allocator() throw();
	};
	
	template<class charT, class traits = char_traits<charT>, class Allocator = allocator<charT> >
	class basic_string {
	public:
		explicit basic_string(const Allocator& a = Allocator());
		basic_string(const charT* s, const Allocator& a = Allocator());

		const charT* c_str() const;
	};

	typedef basic_string<char> string;
}

//// Test code /////

void bad1(char *str) {
    // BAD -- Not allocating space for '\0' terminator
    char *buffer = (char *)malloc(strlen(str));
    std::string str2(buffer);
    free(buffer);
}
