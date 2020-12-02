
class MyInt
{
public:
  MyInt(int _value) : value(_value) {};

  MyInt operator+(const MyInt &rhs)
  {
    return MyInt(value + rhs.value);
  }

  MyInt &operator+=(const MyInt &rhs)
  {
    value += rhs.value;
    return *this;
  }

  MyInt &operator++() // ++x
  {
    value++;
    return *this;
  }

  MyInt operator++(int) // x++
  {
    MyInt result(value);
    value++;
    return result;
  }

  MyInt &operator>>=(int amount)
  {
    value >>= amount;
    return *this;
  }

  int value;
};

void test(MyInt a, MyInt b)
{
  MyInt c = a + b;
  c += b;
  ++c;
  c++;
  c >>= 4;
}
