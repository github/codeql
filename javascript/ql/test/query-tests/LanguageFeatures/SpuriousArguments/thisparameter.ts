function foo(this: void, x: number) {return;}

foo(45);
foo(null, 45); // $ Alert
