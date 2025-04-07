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

    const buffer = new ArrayBuffer(x);
    const view = new Uint8Array(buffer);
    sink(view); // NOT OK

    const sharedBuffer = new SharedArrayBuffer(x);
    const view1 = new Uint8Array(sharedBuffer);
    sink(view1); // NOT OK

    const transfered = buffer.transfer();
    const transferedView = new Uint8Array(transfered);
    sink(transferedView); // NOT OK

    const transfered2 = buffer.transferToFixedLength();
    const transferedView2 = new Uint8Array(transfered2);
    sink(transferedView2); // NOT OK
}
