function declaration(this: void, x: number) {}

var f = function(this: string, x: number) {}

declare function ambient(this: string, x: number);

class C {
  member(this: C) {}
}

interface I {
  method(this: I);
}

