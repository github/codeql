function test() {
    let x = source();

    let y = new Uint8Array(x);
    sink(y); // NOT OK

    sink(y.buffer); // NOT OK
    sink(y.length);

    var arr = new Uint8Array(y.buffer, y.byteOffset, y.byteLength);
    sink(arr); // NOT OK

    const z = new Uint8Array([1, 2, 3]);
    z.set(y, 3);
    sink(z); // NOT OK

    const sub = y.subarray(1, 3)
    sink(sub); // NOT OK
}
