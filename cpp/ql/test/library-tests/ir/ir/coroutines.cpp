namespace std {
 
  template<class R, class... Args>
  struct coroutine_traits{
    using promise_type = R::promise_type;
  };

  using nullptr_t = decltype(nullptr);

  template<typename Promise>
  struct coroutine_handle {
    constexpr coroutine_handle() noexcept;
    constexpr coroutine_handle( std::nullptr_t ) noexcept;
    coroutine_handle(const coroutine_handle&) noexcept;
    coroutine_handle(coroutine_handle&&) noexcept;

    static coroutine_handle from_promise(Promise&);
    coroutine_handle& operator=(nullptr_t) noexcept;
    coroutine_handle& operator=(const coroutine_handle&) noexcept;
    coroutine_handle& operator=(coroutine_handle&&) noexcept;
    constexpr operator coroutine_handle() const noexcept;

    bool done() const;
    constexpr explicit operator bool() const noexcept;
    
    void operator()() const;
    void resume() const;

    void destroy() const;

    Promise& promise() const;

    constexpr void* address() const noexcept;
    static constexpr coroutine_handle from_address(void *);
  };

  template<typename Promise>
  constexpr bool operator==(coroutine_handle<Promise>, coroutine_handle<Promise>) noexcept;

  struct suspend_always {
    constexpr bool await_ready() const noexcept;
    template<typename Promise> constexpr void await_suspend(coroutine_handle<Promise>) const noexcept;
    constexpr void await_resume() const noexcept;
  };
}

class co_returnable_void {
  public:
    struct promise_type;
    co_returnable_void(std::coroutine_handle<promise_type>);

    co_returnable_void(co_returnable_void&) = delete;
    co_returnable_void(co_returnable_void&&) = delete;
};

struct co_returnable_void::promise_type {
  std::coroutine_handle<promise_type> get_return_object();
  std::suspend_always initial_suspend() noexcept;
  std::suspend_always final_suspend() noexcept;

  void return_void();
  void unhandled_exception();

  std::suspend_always yield_value(int);
};

class co_returnable_value {
  public:
    struct promise_type;
    co_returnable_value(std::coroutine_handle<promise_type>);

    co_returnable_value(co_returnable_value&) = delete;
    co_returnable_value(co_returnable_value&&) = delete;
};

struct co_returnable_value::promise_type {
  std::coroutine_handle<promise_type> get_return_object();
  std::suspend_always initial_suspend() noexcept;
  std::suspend_always final_suspend() noexcept;

  void return_value(int);
  void unhandled_exception();

  std::suspend_always yield_value(int);
};

co_returnable_void co_return_void() {
  co_return;
}

co_returnable_value co_return_int(int i) {
  co_return i;
}

co_returnable_void co_yield_value_void(int i) {
  co_yield i;
}

co_returnable_value co_yield_value_value(int i) {
  co_yield i;
}

co_returnable_void co_yield_and_return_void(int i) {
  co_yield i;
  co_return;
}

co_returnable_value co_yield_and_return_value(int i) {
  co_yield i;
  co_return (i + 1);
}



// semmle-extractor-options: -std=c++20