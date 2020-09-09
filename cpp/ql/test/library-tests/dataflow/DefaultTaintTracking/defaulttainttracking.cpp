#include "shared.h"










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

void flow_to_outparam(char ** ret, char *arg) {
    *ret = arg; 
}

void test_outparams() {
    char *p2 = nullptr;
    flow_to_outparam(&p2, getenv("VAR"));
    sink(p2); // tainted
}




struct XY {
  int x;
  int y;
};

void taint_y(XY *xyp) {
  int tainted = getenv("VAR")[0];
  xyp->y = tainted;
}

void test_conflated_fields3() {
  XY xy;
  xy.x = 0;
  taint_y(&xy);
  sink(xy.x); // not tainted
}

struct Point {
  int x;
  int y;

  void callSink() {
    sink(this->x); // tainted
    sink(this->y); // not tainted
  }
};

void test_conflated_fields1() {
  Point p;
  p.x = getenv("VAR")[0];
  sink(p.x); // tainted
  sink(p.y); // not tainted
  p.callSink();
}

void taint_x(Point *pp) {
  pp->x = getenv("VAR")[0];
}

void y_to_sink(Point *pp) {
  sink(pp->y); // not tainted
}

void test_conflated_fields2() {
  Point p;
  taint_x(&p);
  y_to_sink(&p);
}

void sink(Point*);
void sink(Point);

void test_field_to_obj_taint_object(Point p) {
  p.x = getenv("VAR")[0];
  sink(p); // not tainted
  sink(p.x); // tainted
}

void test_field_to_obj_taint_object_addrof(Point p) {
  taint_x(&p);
  sink(p); // tainted [field -> object]
  sink(&p); // tainted [field -> object]
  sink(p.x); // tainted
}

void test_field_to_obj_taint_pointer(Point* pp) {
  pp->x = getenv("VAR")[0];
  sink(pp); // tainted [field -> object]
  sink(*pp); // not tainted
}

void call_sink_on_object(Point* pp) {
  sink(pp); // tainted [field -> object]
  sink(*pp); // tainted [field -> object]
}

void test_field_to_obj_taint_call_sink(Point* pp) {
  pp->x = getenv("VAR")[0];
  call_sink_on_object(pp);
}

void test_field_to_obj_taint_through_setter(Point* pp) {
  taint_x(pp);
  sink(pp); // tainted [field -> object]
  sink(*pp); // not tainted
}

Point* getPoint();

void test_field_to_obj_local_variable() {
  Point* pp = getPoint();
  pp->x = getenv("VAR")[0];
  sink(pp); // not tainted
  sink(*pp); // not tainted
}

void test_field_to_obj_taint_array(Point* pp, int i) {
  pp[0].x = getenv("VAR")[0];
  sink(pp[i]); // not tainted
  sink(pp); // tainted [field -> object]
  sink(*pp); // not tainted
}

void test_field_to_obj_test_pointer_arith(Point* pp) {
  (pp + sizeof(*pp))->x = getenv("VAR")[0];
  sink(pp); // tainted [field -> object]
  sink(pp + sizeof(*pp)); // tainted [field -> object]
}