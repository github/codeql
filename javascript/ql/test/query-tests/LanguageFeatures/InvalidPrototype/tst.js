var o1 = { __proto__: null };
Object.setPrototypeOf(o1, Function.prototype);
Object.create(class{});
Function.prototype.isPrototypeOf(o1);
o1.__proto__ = new Date();

var o2 = { __proto__: undefined };              // $ Alert
Object.setPrototypeOf(o2, 42);                  // $ Alert
Object.create(true);                            // $ Alert
"function".isPrototypeOf(o2);                   // $ Alert

