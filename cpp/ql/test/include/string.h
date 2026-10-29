#if !defined(CODEQL_STRING_H)
#define CODEQL_STRING_H

#include "iterator.h"

namespace std
{
	template<class charT> struct char_traits;

	typedef size_t streamsize;

	template <class T> class allocator {
	public:
		allocator() throw();
		typedef size_t size_type;
	};

	template<class charT, class traits = char_traits<charT>, class Allocator = allocator<charT> >
	class basic_string {
	public:
		using value_type = charT;
		using reference = value_type&;
		using const_reference = const value_type&;
		typedef typename Allocator::size_type size_type;
		static const size_type npos = -1;

		explicit basic_string(const Allocator& a = Allocator());
		basic_string(const charT* s, const Allocator& a = Allocator());
		template<class InputIterator> basic_string(InputIterator begin, InputIterator end, const Allocator& a = Allocator());

		const charT* c_str() const;
		charT* data() noexcept;
		size_t length() const;

		typedef std::iterator<random_access_iterator_tag, charT> iterator;
		typedef std::iterator<random_access_iterator_tag, const charT> const_iterator;

		iterator begin();
		iterator end();
		const_iterator begin() const;
		const_iterator end() const;
		const_iterator cbegin() const;
		const_iterator cend() const;

		void push_back(charT c);

		const charT& front() const;
		charT& front();
		const charT& back() const;
		charT& back();

		const_reference operator[](size_type pos) const;
		reference operator[](size_type pos);
		const_reference at(size_type n) const;
		reference at(size_type n);
		template<class T> basic_string& operator+=(const T& t);
		basic_string& operator+=(const charT* s);
		basic_string& append(const basic_string& str);
		basic_string& append(const charT* s);
		basic_string& append(size_type n, charT c);
		template<class InputIterator> basic_string& append(InputIterator first, InputIterator last); 
		basic_string& assign(const basic_string& str);
		basic_string& assign(size_type n, charT c);
		template<class InputIterator> basic_string& assign(InputIterator first, InputIterator last);
		basic_string& insert(size_type pos, const basic_string& str);
		basic_string& insert(size_type pos, size_type n, charT c);
		basic_string& insert(size_type pos, const charT* s);
		iterator insert(const_iterator p, size_type n, charT c);
		template<class InputIterator> iterator insert(const_iterator p, InputIterator first, InputIterator last); 
		basic_string& replace(size_type pos1, size_type n1, const basic_string& str);
		basic_string& replace(size_type pos1, size_type n1, size_type n2, charT c);
		size_type copy(charT* s, size_type n, size_type pos = 0) const;
		void clear() noexcept;
		basic_string substr(size_type pos = 0, size_type n = npos) const;
		void swap(basic_string& s) noexcept/*(allocator_traits<Allocator>::propagate_on_container_swap::value || allocator_traits<Allocator>::is_always_equal::value)*/;
	};

	template<class charT, class traits, class Allocator> basic_string<charT, traits, Allocator> operator+(const basic_string<charT, traits, Allocator>& lhs, const basic_string<charT, traits, Allocator>& rhs);
	template<class charT, class traits, class Allocator> basic_string<charT, traits, Allocator> operator+(const basic_string<charT, traits, Allocator>& lhs, const charT* rhs);
	template<class charT, class traits, class Allocator> basic_string<charT, traits, Allocator> operator+(const charT* lhs, const basic_string<charT, traits, Allocator>& rhs);

	typedef basic_string<char> string;
}

#endif