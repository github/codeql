
class MyEnumClass {
public:
    enum MyEnum {
        A,
        B
    };
};

static const MyEnumClass::MyEnum v = MyEnumClass::A;

class MyClass2 {
public:
    inline MyClass2(MyEnumClass::MyEnum p) { }
};

void f() {
    MyClass2 mc2 = MyClass2(true ? MyEnumClass::A : v);
}
