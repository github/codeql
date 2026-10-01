#ifndef CODEQL_TEST_STD_STRING_H
#define CODEQL_TEST_STD_STRING_H

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
}

#endif
