import 'dummy';

function t1() {
    const b1 = Buffer.from(source("t1.1"));
    const b2 = Buffer.from(source("t1.2"));
    sink(Buffer.concat([b1, b2]).toString("utf8")); // $ hasTaintFlow=t1.1 hasTaintFlow=t1.2
}
