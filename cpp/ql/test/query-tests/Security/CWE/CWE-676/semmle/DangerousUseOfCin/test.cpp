// Semmle test case for rule DangerousUseOfCin.ql
// Associated with CWE-676: Use of Potentially Dangerous Function. http://cwe.mitre.org/data/definitions/676.html

/*
 * Library definitions
 */

typedef unsigned long size_t;

namespace std
{
	template<class charT> struct char_traits;

	typedef size_t streamsize;

	class ios_base {
	public:
		streamsize width(streamsize wide);
	};

	template <class charT, class traits = char_traits<charT> >
	class basic_ios : public ios_base {
	public:
	};

	template<class charT> struct char_traits;

	template <class charT, class traits = char_traits<charT> >
	class basic_istream : virtual public basic_ios<charT,traits> {
	public:
	};

	template<class charT, class traits> basic_istream<charT,traits>& operator>>(basic_istream<charT,traits>&, charT*);

	typedef basic_istream<char> istream;

	extern istream cin;
}

/*
 * Test case
 */

using namespace std;

#define BUFFER_SIZE 20

void bad()
{
	char buffer[BUFFER_SIZE];
	// BAD: Use of 'cin' without specifying the length of the input.
	cin >> buffer;
	buffer[BUFFER_SIZE-1] = '\0';
}

void good()
{
	char buffer[BUFFER_SIZE];
	// GOOD: Specifying the length of the input before using 'cin'.
	cin.width(BUFFER_SIZE);
	cin >> buffer;
	buffer[BUFFER_SIZE-1] = '\0';
}
