import 'dummy';

let trackedProp = "implicit-receiver-prop"; // name: implicit-receiver-prop

function factory() {
    let obj = unknown(); // name: implicit-receiver-obj
    obj.foo = function() {
        track(this); // track: implicit-receiver-obj
        track(this.x); // track: implicit-receiver-obj track: implicit-receiver-prop
    }
    return obj;
}
let obj = factory();
obj.x = trackedProp;


function factory2() {
    let obj2 = { // name: implicit-receiver-obj2
        foo: function() {
            track(this); // track: implicit-receiver-obj2
            track(this.x); // track: implicit-receiver-obj2 track: implicit-receiver-prop
        }
    }
    return obj2;
}
let obj2 = factory2()
obj2.x = trackedProp;
