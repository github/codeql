
static void mut_unused_function(void);
static void mut_unused_function2(void);

static void mut_unused_function(void) {
    mut_unused_function2();
}

static void mut_unused_function2(void) {
    mut_unused_function();
}

static void f(void) { }
static void g(void) { f(); }
static void h(void) { void (*fun)(void) = g; }
static void i(void) { h(); }
static void j(void) { i(); }
void k(void) { j(); }

