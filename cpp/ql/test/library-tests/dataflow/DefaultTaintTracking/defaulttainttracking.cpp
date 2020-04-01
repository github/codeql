int atoi(const char *nptr);
char *getenv(const char *name);
char *strcat(char * s1, const char * s2);

char *strdup(const char *);
char *_strdup(const char *);
char *unmodeled_function(const char *);

void sink(const char *);
void sink(int);

int main(int argc, char *argv[]) {



  sink(_strdup(getenv("VAR")));
  sink(strdup(getenv("VAR")));
  sink(unmodeled_function(getenv("VAR")));

  char untainted_buf[100] = "";
  char buf[100] = "VAR = ";
  sink(strcat(buf, getenv("VAR")));

  sink(buf);
  sink(untainted_buf); // the two buffers would be conflated if we added flow through all partial chi inputs

  return 0;
}

typedef unsigned int inet_addr_retval;
inet_addr_retval inet_addr(const char *dotted_address);
void sink(inet_addr_retval);

void test_indirect_arg_to_model() {
    // This test is non-sensical but carefully arranged so we get data flow into
    // inet_addr not through the function argument but through its associated
    // read side effect.
    void *env_pointer = getenv("VAR"); // env_pointer is tainted, not its data.
    inet_addr_retval a = inet_addr((const char *)&env_pointer);
    sink(a);
}

class B {
    public:
    virtual void f(const char*) = 0;
};

class D1 : public B {};

class D2 : public D1 {
    public:
    void f(const char* p) override {}
};

class D3 : public D2 {
    public:
    void f(const char* p) override {
        sink(p);
    }
};

void test_dynamic_cast() {
    B* b = new D3();
    b->f(getenv("VAR")); // tainted

    ((D2*)b)->f(getenv("VAR")); // tainted
    static_cast<D2*>(b)->f(getenv("VAR")); // tainted
    dynamic_cast<D2*>(b)->f(getenv("VAR")); // tainted
    reinterpret_cast<D2*>(b)->f(getenv("VAR")); // tainted

    B* b2 = new D2();
    b2->f(getenv("VAR"));

    ((D2*)b2)->f(getenv("VAR"));
    static_cast<D2*>(b2)->f(getenv("VAR"));
    dynamic_cast<D2*>(b2)->f(getenv("VAR"));
    reinterpret_cast<D2*>(b2)->f(getenv("VAR"));

    dynamic_cast<D3*>(b2)->f(getenv("VAR")); // tainted [FALSE POSITIVE]
}

namespace std {
  template< class T >
  T&& move( T&& t ) noexcept;
}

void test_std_move() {
  sink(std::move(getenv("VAR")));
}