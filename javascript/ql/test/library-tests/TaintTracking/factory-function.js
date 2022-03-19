import * as dummy from 'dummy';

var objectA = function(){
    return {};
}
objectA.set = function (obj){
    sink(obj);
};

function factory() {
    var objectB = function(){
        return {};
    }

    objectB.set = function (obj){
        sink(obj); // NOT OK
    };
    return objectB;
}

objectA.set(source());
objectA.set(source());

factory();
b = factory();
b.set(source())
b.set(source())
