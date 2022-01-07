#include "../shared.h"










int main() {



  sink(_strdup(getenv("VAR"))); // $ ir MISSING: ast
  sink(strdup(getenv("VAR"))); // $ ast,ir
  sink(unmodeled_function(getenv("VAR"))); // clean by assumption

  char untainted_buf[100] = "";
  char buf[100] = "VAR = ";
  sink(strcat(buf, getenv("VAR"))); // $ ast MISSING: ir

  sink(buf); // $ ast,ir
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
    sink(a); // $ ast,ir
}

namespace std {
  template< class T >
  T&& move( T&& t ) noexcept;
}

void test_std_move() {
  sink(std::move(getenv("VAR"))); // $ ir MISSING: ast
}

void flow_to_outparam(char ** ret, char *arg) {
    *ret = arg; 
}

void test_outparams() {
    char *p2 = nullptr;
    flow_to_outparam(&p2, getenv("VAR"));
    sink(p2); // $ ir MISSING: ast
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
    sink(this->x); // $ ir MISSING: ast
    sink(this->y); // not tainted
  }
};

void test_conflated_fields1() {
  Point p;
  p.x = getenv("VAR")[0];
  sink(p.x); // $ ir MISSING: ast
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
  sink(p.x); // $ ir MISSING: ast
}

void test_field_to_obj_taint_object_addrof(Point p) {
  taint_x(&p);
  sink(p); // not tainted
  sink(&p);  // not tainted
  sink(p.x); // $ ir MISSING: ast
}

void test_field_to_obj_taint_pointer(Point* pp) {
  pp->x = getenv("VAR")[0];
  sink(pp);// not tainted
  sink(*pp); // not tainted
}

void call_sink_on_object(Point* pp) {
  sink(pp);// not tainted
  sink(*pp);// not tainted
}

void test_field_to_obj_taint_call_sink(Point* pp) {
  pp->x = getenv("VAR")[0];
  call_sink_on_object(pp);
}

void test_field_to_obj_taint_through_setter(Point* pp) {
  taint_x(pp);
  sink(pp);// not tainted
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
  sink(pp);// not tainted
  sink(*pp); // not tainted
}

void test_field_to_obj_test_pointer_arith(Point* pp) {
  (pp + sizeof(*pp))->x = getenv("VAR")[0];
  sink(pp);// not tainted
  sink(pp + sizeof(*pp));// not tainted
}

void sink(char **);

void test_pointers1()
{
	char buffer[1024];
	char *s = getenv("VAR");
	char *ptr1, **ptr2;
	char *ptr3, **ptr4;

	ptr1 = buffer;
	ptr2 = &ptr1;
	memcpy(buffer, s, 1024);
	ptr3 = buffer;
	ptr4 = &ptr3;

	sink(buffer); // $ ast,ir
	sink(ptr1); // $ ast MISSING: ir
	sink(ptr2); // $ SPURIOUS: ast
	sink(*ptr2); // $ ast MISSING: ir
	sink(ptr3); // $ ast,ir
	sink(ptr4); // $ SPURIOUS: ast,ir
	sink(*ptr4); // $ ast,ir
}

void test_pointers2()
{
	char buffer[1024];
	char *s = getenv("VAR");
	char *ptr1, **ptr2;
	char *ptr3, **ptr4;

	ptr1 = buffer;
	ptr2 = &ptr1;
	memcpy(*ptr2, s, 1024);
	ptr3 = buffer;
	ptr4 = &ptr3;

	sink(buffer); // $ MISSING: ast,ir
	sink(ptr1); // $ ast MISSING: ir
	sink(ptr2); // $ SPURIOUS: ast,ir
	sink(*ptr2); // $ ast,ir
	sink(ptr3); // $ MISSING: ast,ir
	sink(ptr4); // clean
	sink(*ptr4); // $ MISSING: ast,ir
}

// --- recv ---

int recv(int s, char* buf, int len, int flags);

void test_recv() {
	char buffer[1024];
	recv(0, buffer, sizeof(buffer), 0);
	sink(buffer); // $ ast,ir
	sink(*buffer); // $ ast,ir
}

// --- send and related functions ---

int send(int, const void*, int, int);

void test_send(char* buffer, int length) {
  send(0, buffer, length, 0); // $ remote
}

struct iovec {
  void  *iov_base;
  unsigned iov_len;
};

int readv(int, const struct iovec*, int);
int writev(int, const struct iovec*, int);

void sink(const iovec* iovs);
void sink(iovec);

int test_readv_and_writev(iovec* iovs) {
  readv(0, iovs, 16);
  sink(iovs); // $ast,ir
  sink(iovs[0]); // $ast,ir
  sink(*iovs); // $ast,ir

  char* p = (char*)iovs[1].iov_base;
  sink(p); // $ MISSING: ast,ir
  sink(*p); // $ MISSING: ast,ir

  writev(0, iovs, 16); // $ remote
}
