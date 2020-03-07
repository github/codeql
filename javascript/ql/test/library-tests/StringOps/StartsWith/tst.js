import * as _ from 'lodash';
import * as R from 'ramda';
let strings = goog.require('goog.string');

function f(A, B) {
    if (A.startsWith(B)) {}
    if (_.startsWith(A, B)) {}
    if (R.startsWith(A, B)) {}
    if (A.indexOf(B) === 0) {}
    if (A.indexOf(B) !== 0) {}
    if (0 !== A.indexOf(B)) {}
    if (0 != A.indexOf(B)) {}
    if (A.indexOf(B)) {}  // !startsWith
    if (!A.indexOf(B)) {} // startsWith
    if (!!A.indexOf(B)) {} // !startsWith
    if (A.substring(0, B.length) === B) {}
    if (A.substring(0, B.length) !== B) {}
    if (A.substr(0, B.length) === B) {}
    if (A.substring(0, 4) === "web/") {}

    // non-examples
    if (_.startsWith(A, B, 2)) {} 
    if (A.indexOf(B) >= 0) {}
    if (A.indexOf(B) === 1) {}
    if (A.indexOf(B) === A.indexOf(B)) {}
    if (A.indexOf(B) !== -1) {}
    if (A.indexOf(B, 2) === 0) {}
    if (A.indexOf(B, 2)) {}
    if (~A.indexOf(B)) {} // checks for existence, not startsWith
    if (A.substring(B.length) === 0) {}

    if (strings.startsWith(A, B)) {}
    if (strings.caseInsensitiveStartsWith(A, B)) {}
    if (A.slice(0, B.length) !== B) {}
    if (A.slice(0, B.foo.length) !== B.foo) {}
}
