template <typename T>
struct Box {
  Box(T&& apple) noexcept(__has_nothrow_copy(T)) {
    T banana = apple;
  }
};

template <typename T>
inline Box<T> box(T&& carrot) {
  return Box<T>((T&&)carrot);
}
