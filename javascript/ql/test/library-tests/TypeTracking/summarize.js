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

identity({});
load({});
store({});
loadStore({});

const obj = {}; // name: obj

let x = identity(obj);
x; // track: obj

x = load({ loadProp: obj });
x; // track: obj

x = store(obj);
x.storeProp; // track: obj

x = loadStore({ loadProp: obj });
x.storeProp; // track: obj
