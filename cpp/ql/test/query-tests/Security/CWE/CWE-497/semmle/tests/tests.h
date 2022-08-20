
typedef unsigned long size_t;

namespace std
{
	typedef size_t streamsize;

	template<class charT> struct char_traits;

	template <class charT, class traits = char_traits<charT> >
	class basic_ostream /*: virtual public basic_ios<charT,traits> - not needed for this test */ {
	public:
		typedef charT char_type;
		basic_ostream<charT,traits>& write(const char_type* s, streamsize n);

		basic_ostream<charT, traits>& operator<<(int n);
	};
	template<class charT, class traits> basic_ostream<charT,traits>& operator<<(basic_ostream<charT,traits>&, const charT*);

	typedef basic_ostream<char> ostream;

	extern ostream cout;
	extern ostream cerr;
	extern ostream clog;
}
