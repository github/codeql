struct empty { };

template <typename T>
struct indirect {
    typedef empty real;
};

template <typename i>
struct S : indirect<int>::real {
};
/*
Currently S's base class is simply 'empty'. We might want a
way to reach the unevaluated 'indirect<int>::real'.
*/

S<int> x;

