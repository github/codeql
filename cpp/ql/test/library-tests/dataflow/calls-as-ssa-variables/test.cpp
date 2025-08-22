namespace std
{
  struct ptrdiff_t;
  struct input_iterator_tag
  {
  };
  struct forward_iterator_tag : public input_iterator_tag
  {
  };
}

struct A
{
  using value_type = int;
  using difference_type = std::ptrdiff_t;
  using pointer = int*;
  using reference = int&;
  using iterator_category = std::forward_iterator_tag;
};

A get();

void test()
{
  while (true)
  {
    auto &&x = get();
  }
}
