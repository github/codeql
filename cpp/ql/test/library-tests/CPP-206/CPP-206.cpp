template <int I> struct Int {};

template <int Ia, int Ja>
constexpr bool operator==(Int<Ia> lhs, Int<Ja> rhs) { return Ia == Ja; }

template <int Ib, int Jb>
struct AsArraySize
{
  char arr[Int<Ib>() == Int<Jb>()];
};

template <int Ic, int Jc>
constexpr int operator+(Int<Ic> lhs, Int<Jc> rhs) { return Ic + Jc; }

template <int Id, int Jd>
struct Sum : Int<Int<Id>() + Int<Jd>()> { };
