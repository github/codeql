export function f1(x) {
    sink(x); // $ hasValueFlow=file1.1
}

export class C {
    f2(x) {
        sink(x); // $ hasValueFlow=file1.2
    }
}

exports.f3 = function(x) {
    sink(x); // $ hasValueFlow=file1.3
}

module.exports.f4 = function(x) {
    sink(x); // $ hasValueFlow=file1.4
}

module.exports = {
    f5: function(x) {
        sink(x); // $ hasValueFlow=file1.5
    }
}

module.exports = function f6() {
    sink(x); // $ MISSING: hasValueFlow=file1.6
}

export { foo } from './reExported.js';
export { foo as bar } from './reExported.js';
