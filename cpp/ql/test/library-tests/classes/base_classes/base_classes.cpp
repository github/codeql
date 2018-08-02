struct empty { };

template <typename T>
struct indirect {
    typedef empty real;
};

template <typename i>
struct S : indirect<int>::real {
};
/*
Currently 'indirect<int>' isn't in the database; the base class is
simply 'empty'. We might want to also include 'indirect<int>', with a
way to reach the unevaluated 'indirect<int>::real'.
*/

S<int> x;

