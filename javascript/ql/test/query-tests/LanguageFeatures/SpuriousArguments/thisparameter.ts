function foo(this: void, x: number) {return;}

foo(45); // OK
foo(null, 45); // NOT OK
