#define FILE int
#define wchar char
#define size_t int
typedef int streamsize;

size_t fwrite(const void *ptr, size_t size, size_t nmemb, FILE *stream);
int fputs(const char *s, FILE *stream); 
int fputc(int c, FILE *stream);
int fprintf(FILE *stream, const char *format, ...);
int sprintf(char *s, const char *format, ...);
size_t strlen(const char *s);

namespace std
{
	template<class charT> struct char_traits;

	template <class charT, class traits = char_traits<charT> >
	class basic_ostream /*: virtual public basic_ios<charT,traits> - not needed for this test */ {
	public:
		typedef charT char_type;
		basic_ostream<charT,traits>& write(const char_type* s, streamsize n);
	};

	template <class charT, class traits = char_traits<charT> >
	class basic_ofstream : public basic_ostream<charT,traits> {
	public:
	};

	template<class charT, class traits> basic_ostream<charT,traits>& operator<<(basic_ostream<charT,traits>&, const charT*);

	typedef basic_ostream<char> ostream;
	typedef basic_ofstream<char> ofstream;
};

using namespace std;

char *encrypt(char *buffer);

// test for CleartextFileWrite
void file() {
  char *thePassword = "cleartext password!";
  FILE *file;

  // BAD: write password to file in cleartext
  fputs(thePassword, file);

  // GOOD: encrypt first
  char *encrypted = encrypt(thePassword);
  fwrite(encrypted, sizeof(encrypted), 1, file);
}

// test for CleartextBufferWrite
int main(int argc, char** argv) {
  char *input = argv[2];
  char *passwd;

  // BAD: write password to buffer in cleartext
  sprintf(passwd, "%s", input);

  // GOOD: encrypt first
  sprintf(passwd, "%s", encrypt(input)); 
}

// test for CleartextFileWrite
void stream() {
  char *thePassword = "cleartext password!";
  ofstream mystream;

  // BAD: write password to file in cleartext
  mystream << "the password is: " << thePassword;

  // BAD: write password to file in cleartext
  (mystream << "the password is: ").write(thePassword, strlen(thePassword));

  // GOOD: encrypt first
  char *encrypted = encrypt(thePassword);
  mystream << "the password is: " << encrypted;
  (mystream << "the password is: ").write(encrypted, strlen(encrypted));
}
