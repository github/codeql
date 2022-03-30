
typedef int type1;
using using1 = float;

typedef using1 type2;
using using2 = type1;

template<typename T> struct S { using X = T*; };

using Y = S<int>::X;
