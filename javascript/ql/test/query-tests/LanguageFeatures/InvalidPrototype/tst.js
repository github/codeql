var o1 = { __proto__: null };                   // OK
Object.setPrototypeOf(o1, Function.prototype);  // OK
Object.create(class{});                         // OK
Function.prototype.isPrototypeOf(o1);           // OK
o1.__proto__ = new Date();                      // OK

var o2 = { __proto__: undefined };              // NOT OK
Object.setPrototypeOf(o2, 42);                  // NOT OK
Object.create(true);                            // NOT OK
"function".isPrototypeOf(o2);                   // NOT OK

