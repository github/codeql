function test() {
    let x = source();

    sink(x); // NOT OK
    sink("/" + x + "!"); // NOT OK

    sink(x == null); // OK
    sink(x == undefined); // OK
    sink(x == 1); // OK
    sink(x === 1); // OK
    sink(undefined == x); // OK
    sink(x === x); // OK

    sink(x.sort()); // NOT OK

    var a = [];
    sink(a); // OK
    a.push(x);
    sink(a); // NOT OK

    var b = [];
    b.unshift(x);
    sink(b); // NOT OK

    sink(x.pop()); // NOT OK
    sink(x.shift()); // NOT OK
    sink(x.slice()); // NOT OK
    sink(x.splice()); // NOT OK

    sink(Array.from(x)); // NOT OK

    x.map((elt, i, ary) => {
        sink(elt); // NOT OK
        sink(i); // OK
        sink(ary); // NOT OK
    });

    x.forEach((elt, i, ary) => {
        sink(elt); // NOT OK
        sink(i); // OK
        sink(ary); // NOT OK
    });

    sink(innocent.map(() => x)); // NOT OK
    sink(x.map(x2 => x2)); // NOT OK

    sink(Buffer.from(x, 'hex')); // NOT OK
    sink(new Buffer(x));         // NOT OK

    const serializeJavaScript = require("serialize-javascript");
    sink(serializeJavaScript(x)) // NOT OK

    function tagged(strings, safe, unsafe) {
        sink(unsafe) // NOT OK
        sink(safe) // OK
        sink(strings) // OK
    }

    tagged`foo ${"safe"} bar ${x} baz`;

    sink(x.reverse()); // NOT OK
    sink(x.toSpliced()); // NOT OK

    sink(x.toSorted()) // NOT OK
    const xSorted = x.toSorted();
    sink(xSorted) // NOT OK

    sink(x.toReversed()) // NOT OK
    const xReversed = x.toReversed();
    sink(xReversed) // NOT OK

    sink(Map.groupBy(x, z => z)); // NOT OK
    sink(Custom.groupBy(x, z => z)); // OK
    sink(Object.groupBy(x, z => z)); // NOT OK
    sink(Map.groupBy(source(), (item) => sink(item))); // NOT OK

    { 
        const grouped = Map.groupBy(x, (item) => sink(item)); // NOT OK
        sink(grouped.get(unknown())); // NOT OK
    }
    {
        const list = [source()];
        const grouped = Map.groupBy(list, (item) => sink(item)); // NOT OK
        sink(grouped.get(unknown())); // NOT OK
    }
    {
        const data = source();
        const result = Object.groupBy(data, item => item);
        const taintedValue = result[notDefined()];
        sink(taintedValue); // NOT OK
    }
    {
        const data = source();
        const map = Map.groupBy(data, item => item);
        const taintedValue = map.get(true); 
        sink(taintedValue); // NOT OK
        sink(map.get(true)); // NOT OK
    }

    sink(x.with()) // NOT OK
    const xWith = x.with();
    sink(xWith) // NOT OK
}
