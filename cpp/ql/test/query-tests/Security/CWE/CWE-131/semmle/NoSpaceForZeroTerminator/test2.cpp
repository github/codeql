
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
		typedef size_t size_type;
	};
	
	template<class charT, class traits = char_traits<charT>, class Allocator = allocator<charT> >
	class basic_string {
	public:
		typedef typename Allocator::size_type size_type;
		explicit basic_string(const Allocator& a = Allocator());
		basic_string(const charT* s, const Allocator& a = Allocator());
		basic_string(const charT* s, size_type n, const Allocator& a = Allocator()); 

		const charT* c_str() const;
	};

	typedef basic_string<char> string;
}

//// Test code /////

void bad1(char *str) {
    // BAD -- Not allocating space for '\0' terminator [NOT DETECTED]
    char *buffer = (char *)malloc(strlen(str));
    std::string str2(buffer);
    free(buffer);
}

void good1(char *str) {
    // GOOD --- copy does not overrun due to size limit
    char *buffer = (char *)malloc(strlen(str));
    std::string str2(buffer, strlen(str));
    free(buffer);
}


