#ifndef CODEQL_TEST_BSL_STRING_H
#define CODEQL_TEST_BSL_STRING_H

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
	template <class T> class shared_ptr {
	public:
		T *get() const;
	};
	class streambuf {};
	class istream {};
	class ostream {};
}

#endif
