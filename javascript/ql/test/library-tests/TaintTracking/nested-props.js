import * as dummy from 'dummy';

function storeLoadFlow(obj) {
    obj.x = source();
    sink(obj.x); // NOT OK
}

function storeStoreLoadLoadFlow(obj) {
    obj.x = { y: source() };
    sink(obj.x.y); // NOT OK
}

function loadStoreFlow(obj) {
    obj.x.y = source();
    sink(obj.x.y); // NOT OK - but not found
}

function loadLoadStoreFlow(obj) {
    obj.x.y.z = source();
    sink(obj.x.y.z); // NOT OK - but not found
}

function doStore(obj, x) {
    obj.x = x;
}
function callStoreBackcallFlow(obj) {
    doStore(obj, source());
    sink(obj.x); // NOT OK - but not found
}

function doLoad(obj) {
    return obj.x
}
function storeCallLoadReturnFlow(obj) {
    obj.x = source();
    sink(doLoad(obj)); // NOT OK
}

function id(obj) {
    return obj
}
function storeCallReturnLoadFlow(obj) {
    obj.x = source();
    sink(id(obj).x); // NOT OK
}

function doLoadStore(obj, val) {
    obj.x.y = val;
}
function callStoreBackloadBackcallLoadLoad(obj) {
    doLoadStore(obj, source());
    sink(obj.x.y); // NOT OK - but not found
}

function doLoadLoad(obj) {
    return obj.x.y
}
function storeBackloadCallLoadLoadReturn(obj) {
    obj.x.y = source();
    sink(doLoadStore(obj)); // NOT OK - but not found
}

function doStoreReturn(val) {
    return { x: val }
}
function callStoreReturnLoad() {
    let { x } = doStoreReturn(source());
    sink(x); // NOT OK

    doStoreReturn(null); // ensure multiple call sites exist
}

function doTaintStoreReturn(val) {
    return { x: val + "!!" }
}
function callTaintStoreReturnLoadFlow() {
    let { x } = doTaintStoreReturn(source());
    sink(x); // NOT OK

    doTaintStoreReturn(null); // ensure multiple call sites exist
}
