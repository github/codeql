
///// Library functions //////

typedef unsigned long size_t;

void *malloc(size_t size);
void *realloc(void *ptr, size_t size);
void *calloc(size_t nmemb, size_t size); 
void free(void *ptr);
size_t strlen(const char *s);
size_t wcslen(const wchar_t *s);
char *strcpy(char *s1, const char *s2);
wchar_t *wcscpy(wchar_t *s1, const wchar_t *s2);

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

static void bad1(char *str) {
    // BAD -- Not allocating space for '\0' terminator [NOT DETECTED]
    char *buffer = (char *)malloc(strlen(str));
    std::string str2(buffer);
    free(buffer);
}

static void good1(char *str) {
    // GOOD --- copy does not overrun due to size limit
    char *buffer = (char *)malloc(strlen(str));
    std::string str2(buffer, strlen(str));
    free(buffer);
}

static void bad2(wchar_t *str) {
    // BAD -- Not allocating space for '\0' terminator [NOT DETECTED]
    wchar_t *buffer = (wchar_t *)calloc(wcslen(str), sizeof(wchar_t));
    wcscpy(buffer, str);
    free(buffer);
}

static void bad3(wchar_t *str) {
    // BAD -- Not allocating space for '\0' terminator
    wchar_t *buffer = (wchar_t *)calloc(sizeof(wchar_t), wcslen(str));
    wcscpy(buffer, str);
    free(buffer);
}

static void bad4(char *str) {
    // BAD -- Not allocating space for '\0' terminator
    char *buffer = (char *)realloc(0, strlen(str));
    strcpy(buffer, str);
    free(buffer);
}

// --- custom allocators ---
 
void *MyMalloc1(size_t size) { return malloc(size); }
void *MyMalloc2(size_t size);

void customAllocatorTests(char *str)
{
	{
		char *buffer1 = (char *)MyMalloc1(strlen(str)); // BAD (no room for `\0` terminator)
		strcpy(buffer1, str);
	}

	{
		char *buffer2 = (char *)MyMalloc2(strlen(str)); // BAD (no room for `\0` terminator)
		strcpy(buffer2, str);
	}
}
