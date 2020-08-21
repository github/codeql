
typedef unsigned long size_t;

// --- string ---

namespace std
{
	template<class charT> struct char_traits;

	typedef size_t streamsize;

	struct ptrdiff_t;

	template <class iterator_category,
			  class value_type,
			  class difference_type = ptrdiff_t,
			  class pointer_type = value_type*,
			  class reference_type = value_type&>
	struct iterator {
		iterator &operator++();
		iterator operator++(int);
		bool operator==(iterator other) const;
		bool operator!=(iterator other) const;
		reference_type operator*() const;
	};

	struct input_iterator_tag {};
	struct forward_iterator_tag : public input_iterator_tag {};
	struct bidirectional_iterator_tag : public forward_iterator_tag {};
	struct random_access_iterator_tag : public bidirectional_iterator_tag {};

	template <class T> class allocator {
	public:
		allocator() throw();
		typedef size_t size_type;
	};
	
	template<class charT, class traits = char_traits<charT>, class Allocator = allocator<charT> >
	class basic_string {
	public:
		typedef typename Allocator::size_type size_type;
		static const size_type npos = -1;

		explicit basic_string(const Allocator& a = Allocator());
		basic_string(const charT* s, const Allocator& a = Allocator());

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

		template<class T> basic_string& operator+=(const T& t);
		basic_string& operator+=(const charT* s);
		basic_string& append(const basic_string& str);
		basic_string& append(const charT* s);
		basic_string& append(size_type n, charT c);
		basic_string& assign(const basic_string& str);
		basic_string& assign(size_type n, charT c);
		basic_string& insert(size_type pos, const basic_string& str);
		basic_string& insert(size_type pos, size_type n, charT c);
		basic_string& replace(size_type pos1, size_type n1, const basic_string& str);
		basic_string& replace(size_type pos1, size_type n1, size_type n2, charT c);
		size_type copy(charT* s, size_type n, size_type pos = 0) const;
		void clear() noexcept;
		basic_string substr(size_type pos = 0, size_type n = npos) const;
		void swap(basic_string& s) noexcept/*(allocator_traits<Allocator>::propagate_on_container_swap::value || allocator_traits<Allocator>::is_always_equal::value)*/;
	};

	template<class charT, class traits, class Allocator> basic_string<charT, traits, Allocator> operator+(const basic_string<charT, traits, Allocator>& lhs, const basic_string<charT, traits, Allocator>& rhs);
	template<class charT, class traits, class Allocator> basic_string<charT, traits, Allocator> operator+(const basic_string<charT, traits, Allocator>& lhs, const charT* rhs);

	typedef basic_string<char> string;

	template <class charT, class traits = char_traits<charT> >
	class basic_istream /*: virtual public basic_ios<charT,traits> - not needed for this test */ {
	public:
		basic_istream<charT,traits>& operator>>(int& n);
	};

	template <class charT, class traits = char_traits<charT> >
	class basic_ostream /*: virtual public basic_ios<charT,traits> - not needed for this test */ {
	public:
		typedef charT char_type;
		basic_ostream<charT,traits>& write(const char_type* s, streamsize n);

		basic_ostream<charT, traits>& operator<<(int n);
	};

	template<class charT, class traits> basic_ostream<charT,traits>& operator<<(basic_ostream<charT,traits>&, const charT*);
	template<class charT, class traits, class Allocator> basic_ostream<charT, traits>& operator<<(basic_ostream<charT, traits>& os, const basic_string<charT, traits, Allocator>& str); 

	template<class charT, class traits = char_traits<charT>>
	class basic_iostream : public basic_istream<charT, traits>, public basic_ostream<charT, traits> {
	public:
	};

	template<class charT, class traits = char_traits<charT>, class Allocator = allocator<charT>>
	class basic_stringstream : public basic_iostream<charT, traits> {
	public:
		explicit basic_stringstream(/*ios_base::openmode which = ios_base::out|ios_base::in - not needed for this test*/);

		basic_string<charT, traits, Allocator> str() const;
	};

	using stringstream = basic_stringstream<char>;
}

// --- vector ---

namespace std {
	template<class T, class Allocator = allocator<T>>
	class vector { 
	public:
		using value_type = T;
		using reference = value_type&;
		using const_reference = const value_type&; 
		using size_type = unsigned int;
		using iterator = std::iterator<random_access_iterator_tag, T>;
		using const_iterator = std::iterator<random_access_iterator_tag, const T>;

		vector() noexcept(noexcept(Allocator())) : vector(Allocator()) { }
		explicit vector(const Allocator&) noexcept;
		explicit vector(size_type n, const Allocator& = Allocator());
		vector(size_type n, const T& value, const Allocator& = Allocator()); 
		~vector();

		vector& operator=(const vector& x);
		vector& operator=(vector&& x) noexcept/*(allocator_traits<Allocator>::propagate_on_container_move_assignment::value || allocator_traits<Allocator>::is_always_equal::value)*/;

		iterator begin() noexcept;
		const_iterator begin() const noexcept;
		iterator end() noexcept;
		const_iterator end() const noexcept;

		size_type size() const noexcept;

		reference operator[](size_type n);
		const_reference operator[](size_type n) const;
		const_reference at(size_type n) const;
		reference at(size_type n);
		reference front();
		const_reference front() const;
		reference back();
		const_reference back() const;

		T* data() noexcept;
		const T* data() const noexcept;

		void push_back(const T& x);
		void push_back(T&& x);

		iterator insert(const_iterator position, const T& x);
		iterator insert(const_iterator position, T&& x);
		iterator insert(const_iterator position, size_type n, const T& x);

		void swap(vector&) noexcept/*(allocator_traits<Allocator>::propagate_on_container_swap::value || allocator_traits<Allocator>::is_always_equal::value)*/;

		void clear() noexcept;
	};
}
