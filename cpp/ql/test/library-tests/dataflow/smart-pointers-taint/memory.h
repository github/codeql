
namespace std {
  namespace detail {
    template<typename T>
    class compressed_pair_element {
      T element;

    public:
      compressed_pair_element() = default;
      compressed_pair_element(const T& t) : element(t) {}
      
      T& get() { return element; }

      const T& get() const { return element; }
    };

    template<typename T, typename U>
    struct compressed_pair : private compressed_pair_element<T>, private compressed_pair_element<U> {
      compressed_pair() = default;
      compressed_pair(T& t) : compressed_pair_element<T>(t), compressed_pair_element<U>() {}
      compressed_pair(const compressed_pair&) = delete;
      compressed_pair(compressed_pair<T, U>&&) noexcept = default;

      T& first() { return static_cast<compressed_pair_element<T>&>(*this).get(); }
      U& second() { return static_cast<compressed_pair_element<U>&>(*this).get(); }

      const T& first() const { return static_cast<const compressed_pair_element<T>&>(*this).get(); }
      const U& second() const { return static_cast<const compressed_pair_element<U>&>(*this).get(); }
    };
  }

  template<class T>
  struct default_delete {
    void operator()(T* ptr) const { delete ptr; }
  };

  template<class T>
  struct default_delete<T[]> {
    template<class U>
    void operator()(U* ptr) const { delete[] ptr; }
  };

  template<class T, class Deleter = default_delete<T> >
  class unique_ptr {
  private:
    detail::compressed_pair<T*, Deleter> data;
  public:
    constexpr unique_ptr() noexcept {}
    explicit unique_ptr(T* ptr) noexcept : data(ptr) {}
    unique_ptr(const unique_ptr& ptr) = delete;
    unique_ptr(unique_ptr&& ptr) noexcept = default;

    unique_ptr& operator=(unique_ptr&& ptr) noexcept = default;

    T& operator*() const { return *get(); }
    T* operator->() const noexcept { return get(); }

    T* get() const noexcept { return data.first(); }

    ~unique_ptr() {
      Deleter& d = data.second();
      d(data.first());
    }
  };
  
  template<typename T, class... Args> unique_ptr<T> make_unique(Args&&... args) {
    return unique_ptr<T>(new T(args...)); // std::forward calls elided for simplicity.
  }

  class ctrl_block {
    unsigned uses;

  public:
    ctrl_block() : uses(1) {}

    void inc() { ++uses; }
    bool dec() { return --uses == 0; }

    virtual void destroy() = 0;
    virtual ~ctrl_block() {}
  };

  template<typename T, class Deleter = default_delete<T> >
  struct ctrl_block_impl: public ctrl_block {
    T* ptr;
    Deleter d;

    ctrl_block_impl(T* ptr, Deleter d) : ptr(ptr), d(d) {}
    virtual void destroy() override { d(ptr); }
  };

  template<class T>
  class shared_ptr {
  private:
    ctrl_block* ctrl;
    T* ptr;

    void dec() {
      if(ctrl->dec()) {
        ctrl->destroy();
        delete ctrl;
      }
    }

    void inc() {
      ctrl->inc();
    }

  public:
    constexpr shared_ptr() noexcept = default;
    shared_ptr(T* ptr) : ctrl(new ctrl_block_impl<T>(ptr, default_delete<T>())) {}
    shared_ptr(const shared_ptr& s) noexcept : ptr(s.ptr), ctrl(s.ctrl) {
      inc();
    }
    shared_ptr(shared_ptr&& s) noexcept = default;

    T* operator->() const { return ptr; }

    T& operator*() const { return *ptr; }

    ~shared_ptr() { dec(); }
  };

  template<typename T, class... Args> shared_ptr<T> make_shared(Args&&... args) {
    return shared_ptr<T>(new T(args...)); // std::forward calls elided for simplicity.
  }
}