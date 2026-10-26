
void afun(void) {
    int x = 5;
    auto x2 = x;
    register int y;
}

class MyClass {
    public: 
        explicit MyClass (int n);
        int publicInt;
        void publicFun(void) {}
        virtual int getInt() = 0;
        virtual int f();
    private:
        int privateInt;
        mutable int mutableInt;
        void privateFun(void) {}
    protected:
        int protectedInt;
        void protectedFun(void) {}
};

class MyClass2: public MyClass {
    public:
        virtual int f() override;
};

class SomeClass {
    public:
        int fun(void);
};
int SomeClass::fun(void) {}

class AnotherClass {
    friend class MyClass;
    friend int SomeClass::fun();
};

extern int someFun(int x);
extern "C" int someFun2(int x);
extern "C" {
    int someFun3(int x);
    static int someFun4(int x);
}

typedef int *const const_pointer;

typedef volatile const_pointer volatile_const_pointer;
typedef volatile_const_pointer volatile_const_pointer2;

volatile_const_pointer2 vci = 0;
typedef decltype(vci) volatile_const_pointer3;
typedef __restrict volatile_const_pointer3 volatile_const_restrict_pointer;

template<typename T> using Const = const T;

using Const_int = Const<int>;

typedef volatile Const_int volatile_Const_int;

class TestConstexpr {
    constexpr int member_constexpr() { return 0; } // const in C++11
    constexpr int member_const_constexpr() const { return 0; }
};
