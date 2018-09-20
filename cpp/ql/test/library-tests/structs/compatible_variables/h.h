// Provide an incomplete definition of Foo.
struct Foo;
typedef struct Foo* FooPtr;

// When this file is included from a.c, the extractor will see a complete
// definition of Foo, but not when it's included b.c. We want to check that we
// don't see these variables duplicated in the database because of it.
extern void (*some_func_ptr)(struct Foo *foo);
extern struct Foo* foo_ptr1;
extern FooPtr foo_ptr2;
