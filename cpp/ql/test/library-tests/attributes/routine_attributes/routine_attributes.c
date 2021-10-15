static int dummy() {}

static int named_weakref() __attribute__ ((weakref ("dummy")));
static int aliased_weakref() __attribute__ ((weakref, alias ("dummy")));
static int plain_weakref() __attribute__ ((weakref));
static int plain_alias() __attribute__ ((alias ("dummy")));

static int init_fn() __attribute__((constructor(100)));
static int uninit_fn() __attribute__((destructor(200)));

static int pure_fn() __attribute__((pure));

static int used_fn() __attribute__((used));
static int unused_fn() __attribute__((unused));

static void* my_alloc() __attribute__((malloc));

static int cocktail1() __attribute__((naked, no_instrument_function, no_check_memory_usage, noinline));
static int cocktail2() __attribute__((always_inline, nothrow));
static int impossible() __attribute__((solves_the_halting_problem("No, really!"), cures_cancer, is_batman));
static int empty_attr() __attribute__(());
