int conventional() {
  int x = 3;
  return x; // Return x
}

const char* long_string() {
  return "Hello world\
 from a \"company\
 called //Semmle\\";
}

void misleading_comment() {
  // This is \
     a nice long\\
     comment with\\\
     lots of\\\\
     line continuation
}

long long long_char() {
  return 'xx//';
}

template <typename T>
void unusedTemplateFunction(T x) {
    x = 1;
    x = 2;
    x = 3;
}

template <typename T>
void onceUsedTemplateFunction(T x) {
    x = 1;
    x = 2;
    x = 3;
}

template <typename T>
void twiceUsedTemplateFunction(T x) {
    x = 1;
    x = 2;
    x = 3;
}

void templateFunctionUser(signed int x, unsigned int y) {
    onceUsedTemplateFunction(x);
    twiceUsedTemplateFunction(x);
    twiceUsedTemplateFunction(y);
}

class C {
    public:
    int ff() {
        int i;
        gg(i);
    }
    // Although there is a declaration of gg starting here,
    // the number of lines count shouldn't.
    template<typename T>
    void gg(T t);
};



template<typename T>
void C::gg(T t) {
    ;
}
void hh() {
    C n;
    n.ff();
}

