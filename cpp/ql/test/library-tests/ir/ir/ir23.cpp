constexpr bool consteval_1() noexcept
{
  if consteval {
    return true;
  } else {
    return false;
  }
}
 
constexpr bool consteval_2() noexcept
{
  if ! consteval {
    return true;
  } else {
    return false;
  }
}

constexpr bool consteval_3() noexcept
{
  if consteval {
    return true;
  }

  return false;
}

constexpr bool consteval_4() noexcept
{
  if ! consteval {
    return true;
  }

  return false;
}

constexpr bool consteval_5() noexcept
{
  bool r = true;

  if ! consteval {
    r = false;
  }

  return r;
}

constexpr bool consteval_6() noexcept
{
  bool r = true;

  if consteval {
    r = false;
  }

  return r;
}

// semmle-extractor-options: -std=c++23
