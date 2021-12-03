
// This tickled a bug where the destructor call for 'c' in 'f' could be
// followed by leaving the '~Inner' function, rather than leaving 'f'.

class Class2 {
public:
    Class2();
    ~Class2();
};

Class2 getClass2();

class Outer {
public:
    class Inner {
    public:
        Inner(const Class2 &c) { }
        ~Inner() { }
    };

    void f2(int i) {
        Class2 c = getClass2();
        if(i) {
            return;
        }
        Inner inner(c);
    }
};

