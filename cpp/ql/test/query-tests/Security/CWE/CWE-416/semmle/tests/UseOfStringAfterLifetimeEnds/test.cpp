typedef unsigned long size_t;

namespace std {
  template<class T> struct remove_reference { typedef T type; };

  template<class T> struct remove_reference<T &> { typedef T type; };

  template<class T> struct remove_reference<T &&> { typedef T type; };

  template<class T> using remove_reference_t = typename remove_reference<T>::type;

  template< class T > std::remove_reference_t<T>&& move( T&& t );
}

// --- iterator ---

namespace std {
  template<class T> struct remove_const { typedef T type; };

  template<class T> struct remove_const<const T> { typedef T type; };

  // `remove_const_t<T>` removes any `const` specifier from `T`
  template<class T> using remove_const_t = typename remove_const<T>::type;

  struct ptrdiff_t;

  template<class I> struct iterator_traits;

  template <class Category,
        class value_type,
        class difference_type = ptrdiff_t,
        class pointer_type = value_type*,
        class reference_type = value_type&>
  struct iterator {
    typedef Category iterator_category;

    iterator();
    iterator(iterator<Category, remove_const_t<value_type> > const &other); // non-const -> const conversion constructor

    iterator &operator++();
    iterator operator++(int);
    iterator &operator--();
    iterator operator--(int);
    bool operator==(iterator other) const;
    bool operator!=(iterator other) const;
    reference_type operator*() const;
    pointer_type operator->() const;
    iterator operator+(int);
    iterator operator-(int);
    iterator &operator+=(int);
    iterator &operator-=(int);
    int operator-(iterator);
    reference_type operator[](int);
  };

  struct input_iterator_tag {};
  struct forward_iterator_tag : public input_iterator_tag {};
  struct bidirectional_iterator_tag : public forward_iterator_tag {};
  struct random_access_iterator_tag : public bidirectional_iterator_tag {};
}

// --- string ---

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

    const_reference operator[](size_type pos) const;
    reference operator[](size_type pos);
    const_reference at(size_type n) const;
    reference at(size_type n);
    basic_string& insert(size_type pos, const basic_string& str);
    basic_string& insert(size_type pos, size_type n, charT c);
    basic_string& insert(size_type pos, const charT* s);
    iterator insert(const_iterator p, size_type n, charT c);
    template<class InputIterator> iterator insert(const_iterator p, InputIterator first, InputIterator last); 
    basic_string& replace(size_type pos1, size_type n1, const basic_string& str);
    basic_string& replace(size_type pos1, size_type n1, size_type n2, charT c);
  };

  template<class charT, class traits, class Allocator> basic_string<charT, traits, Allocator> operator+(const basic_string<charT, traits, Allocator>& lhs, const basic_string<charT, traits, Allocator>& rhs);
  template<class charT, class traits, class Allocator> basic_string<charT, traits, Allocator> operator+(const basic_string<charT, traits, Allocator>& lhs, const charT* rhs);

  typedef basic_string<char> string;
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

    vector() noexcept(noexcept(Allocator()));
    explicit vector(const Allocator&) noexcept;
    explicit vector(size_type n, const Allocator& = Allocator());
    vector(size_type n, const T& value, const Allocator& = Allocator());
    template<class InputIterator, class IteratorCategory = typename InputIterator::iterator_category> vector(InputIterator first, InputIterator last, const Allocator& = Allocator());
    ~vector();

    void push_back(const T& x);
    void push_back(T&& x);

    iterator insert(const_iterator position, const T& x);
    iterator insert(const_iterator position, T&& x);
    iterator insert(const_iterator position, size_type n, const T& x);
    template<class InputIterator> iterator insert(const_iterator position, InputIterator first, InputIterator last);

    template <class... Args> iterator emplace (const_iterator position, Args&&... args);
    template <class... Args> void emplace_back (Args&&... args);
  };
}

struct S {
  const char* s;
};

void call_by_value(S);
void call_by_cref(const S&);

void call(const char*);

const char* test1(bool b1, bool b2) {
  auto s1 = std::string("hello").c_str(); // BAD
  auto s2 = b1 ? std::string("hello").c_str() : ""; // BAD
  auto s3 = b2 ? "" : std::string("hello").c_str(); // BAD
  const char* s4;
  s4 = std::string("hello").c_str(); // BAD

  call(std::string("hello").c_str()); // GOOD
  call(b1 ? std::string("hello").c_str() : ""); // GOOD
  call(b1 ? (b2 ? "" : std::string("hello").c_str()) : ""); // GOOD
  call_by_value({ std::string("hello").c_str() }); // GOOD
  call_by_cref({ std::string("hello").c_str() }); // GOOD

  std::vector<const char*> v1;
  v1.push_back(std::string("hello").c_str()); // BAD

  std::vector<S> v2;
  v2.push_back({ std::string("hello").c_str() }); // BAD

  S s5[] = { { std::string("hello").c_str() } }; // BAD

  char c = std::string("hello").c_str()[0]; // GOOD

  auto s6 = std::string("hello").data(); // BAD
  auto s7 = b1 ? std::string("hello").data() : ""; // BAD
  auto s8 = b2 ? "" : std::string("hello").data(); // BAD
  char* s9;
  s9 = std::string("hello").data(); // BAD

  const char* s13 = b1 ? std::string("hello").c_str() : s1; // BAD

  return std::string("hello").c_str(); // BAD
}

void test2(bool b1, bool b2) {
  std::string s("hello");
  auto s1 = s.c_str(); // GOOD
  auto s2 = b1 ? s.c_str() : ""; // GOOD
  auto s3 = b2 ? "" : s.c_str(); // GOOD
  const char* s4;
  s4 = s.c_str(); // GOOD

  std::string& sRef = s;

  auto s5 = sRef.c_str(); // GOOD
  auto s6 = b1 ? sRef.c_str() : ""; // GOOD
  auto s7 = b2 ? "" : sRef.c_str(); // GOOD
  const char* s8;
  s8 = sRef.c_str(); // GOOD

  std::string&& sRefRef = std::string("hello");

  auto s9 = sRefRef.c_str(); // GOOD
  auto s10 = b1 ? sRefRef.c_str() : ""; // GOOD
  auto s11 = b2 ? "" : sRefRef.c_str(); // GOOD
  const char* s12;
  s12 = sRefRef.c_str(); // GOOD
}