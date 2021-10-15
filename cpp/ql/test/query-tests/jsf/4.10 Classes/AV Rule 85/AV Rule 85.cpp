
class MyClass1 {
public:
    int i;
    bool operator< (const MyClass1 &rhs){ return i < rhs.i; }
    // BAD: operator>= missing
};

class MyClass2 {
public:
    int i;
    bool operator< (const MyClass2 &rhs){ return i < rhs.i; }
    bool operator>= (const MyClass2 &rhs){ return i >= rhs.i; }
    // BAD: neither operator defined in terms of the other
};

class MyClass3 {
public:
    int i;
    bool operator< (const MyClass3 &rhs){ return i < rhs.i; }
    bool operator>= (const MyClass3 &rhs){ return !(*this < rhs); }
    // GOOD
};

class MyClass4 {
public:
    int i;
    bool operator< (const MyClass4 &rhs){ return i < rhs.i; }
    bool operator>= (const MyClass4 &rhs){ return !(*this < rhs); }
    // GOOD
    bool operator> (const MyClass4 &rhs){ return i < rhs.i; }
    bool operator<= (const MyClass4 &rhs){ return i >= rhs.i; }
    // BAD: neither operator defined in terms of the other
};

template <typename T>
class MyClass5 {
public:
    int i;
    bool operator< (const MyClass5 &rhs){ return i < rhs.i; }
    bool operator>= (const MyClass5 &rhs){ return !(*this < rhs); }
    // GOOD
    bool operator> (const MyClass5 &rhs){ return i < rhs.i; }
    bool operator<= (const MyClass5 &rhs){ return i >= rhs.i; }
    // BAD: neither operator defined in terms of the other
};

template <typename T>
class MyClass6 {
public:
    int i;
    bool operator< (const MyClass6 &rhs){ return i < rhs.i; }
    bool operator>= (const MyClass6 &rhs){ return !(*this < rhs); }
    // GOOD
    bool operator> (const MyClass6 &rhs){ return i < rhs.i; }
    bool operator<= (const MyClass6 &rhs){ return i >= rhs.i; }
    // BAD: neither operator defined in terms of the other
};
MyClass6<int> myClass6;

template <typename T>
class MyClass7 {
public:
    int i;
    template <typename U>
    bool operator< (const MyClass7<U> &rhs){ return i < rhs.i; }
    template <typename U>
    bool operator>= (const MyClass7<U> &rhs){ return !(*this < rhs); }
    // GOOD
    template <typename U>
    bool operator> (const MyClass7<U> &rhs){ return i < rhs.i; }
    template <typename U>
    bool operator<= (const MyClass7<U> &rhs){ return i >= rhs.i; }
    // BAD: neither operator defined in terms of the other
};
MyClass7<int> myClass7;

template <typename T>
class MyClass8 {
public:
    int i;
    template <typename U>
    bool operator< (const MyClass8<U> &rhs){ return i < rhs.i; }
    template <typename U>
    bool operator>= (const MyClass8<U> &rhs){ return !(*this < rhs); }
    // GOOD
    template <typename U>
    bool operator> (const MyClass8<U> &rhs){ return i < rhs.i; }
    template <typename U>
    bool operator<= (const MyClass8<U> &rhs){ return i >= rhs.i; }
    // BAD: neither operator defined in terms of the other
};
void f8(void) {
    bool b;
    MyClass8<int> myClass8;
    b = myClass8 < myClass8;
    b = myClass8 <= myClass8;
    b = myClass8 > myClass8;
    b = myClass8 >= myClass8;
}

template <typename T>
class MyClass9 {
public:
    int i;
    template <typename U>
    bool operator< (const MyClass9<U> &rhs){ return i < rhs.i; }
    template <typename U>
    bool operator>= (const MyClass9<U> &rhs){ return !(*this < rhs); }
    // GOOD
    template <typename U>
    bool operator> (const MyClass9<U> &rhs){ return i < rhs.i; }
    template <typename U>
    bool operator<= (const MyClass9<U> &rhs){ return i >= rhs.i; }
    // BAD: neither operator defined in terms of the other
};
void f9(void) {
    bool b;
    MyClass9<int> myClass9;
    MyClass9<double> myClass9d;
    b = myClass9 < myClass9;
    b = myClass9 <= myClass9;
    b = myClass9 > myClass9;
    b = myClass9 >= myClass9;
}

template <typename T>
class MyClass10 {
public:
    int i;
    template <typename U>
    bool operator< (const MyClass10<U> &rhs){ return i < rhs.i; }
    template <typename U>
    bool operator>= (const MyClass10<U> &rhs){ return !(*this < rhs); }
    // GOOD
    template <typename U>
    bool operator> (const MyClass10<U> &rhs){ return i < rhs.i; }
    template <typename U>
    bool operator<= (const MyClass10<U> &rhs){ return i >= rhs.i; }
    // BAD: neither operator defined in terms of the other
};
void f10(void) {
    bool b;
    MyClass10<int> myClass10;
    b = myClass10 < myClass10;
    b = myClass10 > myClass10;
}

