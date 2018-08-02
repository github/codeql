template<typename X>
struct __is_integral_helper
{};

template<>
struct __is_integral_helper<char16_t>
{};

template<>
struct __is_integral_helper<unsigned short>
{};

int main() {
  return 0;
}
