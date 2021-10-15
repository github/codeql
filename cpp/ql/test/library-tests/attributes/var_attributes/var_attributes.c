       int weak_var __attribute__((weak));
static int weakref_var __attribute__((weakref));
static int used_var __attribute__((used));
static int unused_var __attribute__((unused));

static void f1(unsigned unused_param __attribute__((unused))) {}
