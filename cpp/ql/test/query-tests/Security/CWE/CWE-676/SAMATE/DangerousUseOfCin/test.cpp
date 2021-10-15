// SAMATE Juliet test case for rule DangerousUseOfCin.ql / CWE-676.

// --- library types, functions etc ---

typedef unsigned long size_t;

namespace std
{
	// --- std::istream ---

	// std::char_traits
	template<class CharT> class char_traits;

	typedef size_t streamsize;

	class ios_base {
	public:
		streamsize width(streamsize wide);
	};

	template <class charT, class traits = char_traits<charT> >
	class basic_ios : public ios_base {
	public:
	};

	// std::basic_istream
	template <class charT, class traits = char_traits<charT> >
	class basic_istream : virtual public basic_ios<charT,traits> {
	};

	// operator>> std::basic_istream -> char*
	template<class charT, class traits> basic_istream<charT,traits>& operator>>(basic_istream<charT,traits>&, charT*);

	// std::istream
	typedef basic_istream<char> istream;

	// --- std::cin ---

	extern istream cin;
}

void printLine(const char *str);

// --- test cases ---

using namespace std;

#define CHAR_BUFFER_SIZE 10

void CWE676_Use_of_Potentially_Dangerous_Function__basic_17_bad()
{
    int j;
    for(j = 0; j < 1; j++)
    {
        {
            char charBuffer[CHAR_BUFFER_SIZE];
            /* FLAW: using cin in an inherently dangerous fashion */
            /* INCIDENTAL CWE120 Buffer Overflow since cin extraction is unbounded. */
            cin >> charBuffer; // BAD
            charBuffer[CHAR_BUFFER_SIZE-1] = '\0';
            printLine(charBuffer);
        }
    }
}

/* good1() changes the conditions on the for statements */
static void CWE676_Use_of_Potentially_Dangerous_Function__basic_17_good1()
{
    int k;
    for(k = 0; k < 1; k++)
    {
        {
            char charBuffer[CHAR_BUFFER_SIZE];
            /* FIX: Use cin after specifying the length of the input */
            cin.width(CHAR_BUFFER_SIZE);
            cin >> charBuffer; // GOOD
            charBuffer[CHAR_BUFFER_SIZE-1] = '\0';
            printLine(charBuffer);
        }
    }
}
