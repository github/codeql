
typedef struct _num_fun {
    int num;
    void (*fun)(void);
} num_fun;

static void f(void) {} // Used, via n1
static void g(void) {} // Not used (n2 is static)
static void h(void) {} // Used, via n3, via j
static void i(void) {} // Not used (k is static)

num_fun n1 = {1, f};
static num_fun n2 = {1, g};
static num_fun n3 = {1, h};

void j(void) { // Used (not static)
    num_fun n = n3;
}

static void k(void) { // Not used (static)
    num_fun n = {1, i};
    n1.fun = i;
}

