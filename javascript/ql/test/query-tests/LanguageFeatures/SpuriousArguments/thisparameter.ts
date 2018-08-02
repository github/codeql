function foo(this: void, x: number) {}

foo(45); // OK
foo(null, 45); // NOT OK
