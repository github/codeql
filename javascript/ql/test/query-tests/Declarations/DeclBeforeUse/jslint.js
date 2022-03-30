/*global w, x:true*/
/* global y*/  // not a proper JSLint global declaration, but we (and JSHint) accept it anyway
/*global: z*/  // also not a proper global declaration
w; // OK
x; // OK
y; // not OK
z; // not OK
var x, y, z;