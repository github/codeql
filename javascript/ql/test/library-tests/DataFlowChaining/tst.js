import 'dummy';

let hasOwnProp = Object.prototype.hasOwnProperty;

function f(obj) {
    obj();

    obj.directMethodCall();

    let prop = obj.prop;
    prop();

    let { destruct } = obj;
    destruct();

    for (let elm of obj) {
        elm();
    }

    obj.reflectiveApply.apply(obj, [1, 2]);
    obj.reflectiveCall.call(obj, 1, 2);

    prop.apply(obj, [1, 2]);
    prop.call(obj, 1, 2);

    let fn = something();
    fn.apply(obj, [1, 2]);
    fn.call(obj, 1, 2);

    let callback = obj.foo || doNothing;
    callback.call(obj, 1, 2); // Not currently seen as method call

    hasOwnProp.call(obj, "hello");
}

function doNothing() {}
