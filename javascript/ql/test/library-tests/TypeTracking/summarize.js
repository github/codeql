import 'dummy';

function identity(x) {
    return x;
}
function load(x) {
    return x.loadProp;
}
function store(x) {
    return { storeProp: x };
}
function loadStore(x) {
    return { storeProp: x.loadProp };
}
function loadStore2(x) {
    let mid = x.loadProp;
    return { storeProp: mid };
}

identity({});
load({});
store({});
loadStore({});
loadStore2({});

const obj = {}; // name: obj

let x = identity(obj);
x; // track: obj

x = load({ loadProp: obj });
x; // track: obj

x = store(obj);
x.storeProp; // track: obj

x = loadStore({ loadProp: obj });
x.storeProp; // track: obj

x = loadStore2({ loadProp: obj });
x.storeProp; // track: obj
