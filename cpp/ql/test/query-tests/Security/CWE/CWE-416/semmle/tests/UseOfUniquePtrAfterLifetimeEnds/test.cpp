typedef unsigned long size_t;

namespace std {
  template<class T> struct remove_reference { typedef T type; };

  template<class T> struct remove_reference<T &> { typedef T type; };

  template<class T> struct remove_reference<T &&> { typedef T type; };

  template<class T> using remove_reference_t = typename remove_reference<T>::type;

  template< class T > std::remove_reference_t<T>&& move( T&& t );

  template< class T > struct default_delete;

  template<class T>  struct add_lvalue_reference { typedef T& type; };
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

  using nullptr_t = decltype(nullptr);

  template<class T, class Deleter = std::default_delete<T>> class unique_ptr {
  public:
    using pointer = T*;
    using element_type = T;
    using deleter_type = Deleter;

    constexpr unique_ptr() noexcept;
    constexpr unique_ptr(nullptr_t) noexcept;
    explicit unique_ptr(pointer p) noexcept;
    unique_ptr(unique_ptr&& u) noexcept;
    template<class U, class E> unique_ptr(unique_ptr<U, E>&& u) noexcept;
    unique_ptr(const unique_ptr&) = delete;

    unique_ptr& operator=(unique_ptr&& u) noexcept;
    unique_ptr& operator=(std::nullptr_t) noexcept;
    template<class U, class E> unique_ptr& operator=(unique_ptr<U, E>&& u) noexcept;
    
    ~unique_ptr();

    pointer get() const noexcept;
    deleter_type& get_deleter() noexcept;
    const deleter_type& get_deleter() const noexcept;
    explicit operator bool() const noexcept;
    typename std::add_lvalue_reference<T>::type operator*() const;
    pointer operator->() const noexcept;
    pointer release() noexcept;
    void reset(pointer p = pointer()) noexcept;
    void swap(unique_ptr& u) noexcept;
  };
}

// --- vector ---

namespace std {
  template <class T> class allocator {
  public:
    allocator() throw();
    typedef size_t size_type;
  };

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

void call(S*);

void call_by_value(S);
void call_by_ref(S&);

std::unique_ptr<S> get_unique_ptr();

const S* test1(bool b1, bool b2) {
  auto s1 = *get_unique_ptr(); // GOOD
  auto s1a = &*get_unique_ptr(); // BAD
  auto s1b = get_unique_ptr().get(); // BAD
  auto s1c = get_unique_ptr()->s; // GOOD
  auto s1d = &(get_unique_ptr()->s); // BAD
  auto s2 = b1 ? get_unique_ptr().get() : nullptr; // BAD
  auto s3 = b2 ? nullptr :get_unique_ptr().get(); // BAD
  const S* s4;
  s4 = get_unique_ptr().get(); // BAD

  call(get_unique_ptr().get()); // GOOD
  call(b1 ? get_unique_ptr().get() : nullptr); // GOOD
  call(b1 ? (b2 ? nullptr : get_unique_ptr().get()) : nullptr); // GOOD
  call_by_value(*get_unique_ptr()); // GOOD
  call_by_ref(*get_unique_ptr()); // GOOD

  std::vector<S*> v1;
  v1.push_back(get_unique_ptr().get()); // BAD

  S* s5[] = { get_unique_ptr().get() }; // BAD

  S s6 = b1 ? *get_unique_ptr() : *get_unique_ptr(); // GOOD
  S& s7 = b1 ? *get_unique_ptr() : *get_unique_ptr(); // BAD

  return &*get_unique_ptr(); // BAD
}

void test2(bool b1, bool b2) {
  
  std::unique_ptr<S> s = get_unique_ptr();
  auto s1 = s.get(); // GOOD
  auto s2 = b1 ?  s.get() : nullptr; // GOOD
  auto s3 = b2 ? nullptr :  s.get(); // GOOD
  const S* s4;
  s4 = s.get(); // GOOD

  std::unique_ptr<S>& sRef = s;

  auto s5 = sRef.get(); // GOOD
  auto s6 = b1 ? sRef.get() : nullptr; // GOOD
  auto s7 = b2 ? nullptr : sRef.get(); // GOOD
  const S* s8;
  s8 = sRef.get(); // GOOD

  std::unique_ptr<S>&& sRefRef = get_unique_ptr();

  auto s9 = sRefRef.get(); // GOOD
  auto s10 = b1 ? sRefRef.get() : nullptr; // GOOD
  auto s11 = b2 ? nullptr : sRefRef.get(); // GOOD
  const S* s12;
  s12 = sRefRef.get(); // GOOD
}

void test_convert_to_bool() {
  bool b = get_unique_ptr().get(); // GOOD

  if(get_unique_ptr().get()) { // GOOD

  }
}