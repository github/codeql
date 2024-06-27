class ClassWithDestructor2 {
public:
    ClassWithDestructor2();
    ~ClassWithDestructor2();

    char get_x();
};

class ClassWithConstructor {
public:
    ClassWithConstructor(char x, char y);
};

char temp_test() {
    char x = ClassWithDestructor2().get_x();
    ClassWithConstructor y('a', ClassWithDestructor2().get_x());
    return ClassWithDestructor2().get_x();
}


char temp_test2() {
    new ClassWithDestructor2();
    return ClassWithDestructor2().get_x() + ClassWithDestructor2().get_x();
}

template<typename T>
T returnValue();

void temp_test3() {
    const ClassWithDestructor2& rs = returnValue<ClassWithDestructor2>();
}

void temp_test4() {
    ClassWithDestructor2 c;
    const ClassWithDestructor2& rs2 = returnValue<ClassWithDestructor2>();
}

void temp_test5(bool b) {
  b ? ClassWithDestructor2() : ClassWithDestructor2();
}

void temp_test6(bool b) {
    ClassWithDestructor2 c;
    if (b) {
      throw ClassWithConstructor('x', ClassWithDestructor2().get_x());
    }
}

void temp_test7(bool b) {
    ClassWithDestructor2 c;
    b ? throw ClassWithConstructor('x', ClassWithDestructor2().get_x()) : ClassWithDestructor2();
}

void temp_test8(bool b) {
    b ? throw ClassWithConstructor('x', ClassWithDestructor2().get_x()) : ClassWithDestructor2();
}

void temp_test8_simple(bool b) {
    b ? throw ClassWithDestructor2().get_x() : 'a';
}

struct string
{
    string(const char *);
    ~string();
};

bool const_ref_string(const string &);

bool conditional_temp_via_conjunction(bool b)
{
    return b && const_ref_string("");
}

ClassWithDestructor2 make();

void temp_test9() {
    make();
}

void temp_test10(int i) {
    while(i < 10) {
        make();
    }
}

struct ClassWithDestructor3 {
    ~ClassWithDestructor3();
    ClassWithDestructor2 getClassWithDestructor2();
};

ClassWithDestructor3 makeClassWithDestructor3();

void temp_test11() {
    // Two destructors are called at the semicolon (i.e., they're both attached
    // to the call to `getClassWithDestructor2()`):
    // First, ~ClassWithDestructor2::ClassWithDestructor2(), and then the call
    // to `~ClassWithDestructor3::ClassWithDestructor3()`.
    makeClassWithDestructor3().getClassWithDestructor2();
}

void temp_test12(ClassWithDestructor3 x) {
    x.getClassWithDestructor2().get_x() + 5;
}