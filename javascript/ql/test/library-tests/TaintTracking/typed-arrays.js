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

    const buffer = new ArrayBuffer(8);
    const view = new Uint8Array(buffer);
    view.set(x, 3);
    sink(buffer); // NOT OK -- Should be flagged but it is not.

    const sharedBuffer = new SharedArrayBuffer(8);
    const view1 = new Uint8Array(sharedBuffer);
    view1.set(x, 3);
    sink(sharedBuffer); // NOT OK -- Should be flagged but it is not.

    const transfered = buffer.transfer();
    const transferedView = new Uint8Array(transfered);
    sink(transferedView); // NOT OK -- Should be flagged but it is not.

    const transfered2 = buffer.transferToFixedLength();
    const transferedView2 = new Uint8Array(transfered2);
    sink(transferedView2); // NOT OK -- Should be flagged but it is not.

    var typedArrayToString = (function () {
        return function (a) { return String.fromCharCode.apply(null, a); };
    })();

    sink(typedArrayToString(y)); // NOT OK

    let str = '';
    for (let i = 0; i < y.length; i++) 
        str += String.fromCharCode(y[i]);
    
    sink(str); // NOT OK

    const decoder = new TextDecoder('utf-8');
    const str2 = decoder.decode(y);
    sink(str2); //  NOT OK
}
