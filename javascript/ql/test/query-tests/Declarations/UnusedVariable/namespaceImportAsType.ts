import * as X from "x"; // OK
import * as Y from "y"; // OK
import * as Z from "z"; // NOT OK

function f(x: X) {}
function g(x: Y.T) {}

f(null);
g(null);
