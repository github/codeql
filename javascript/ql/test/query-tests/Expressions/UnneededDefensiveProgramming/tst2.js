(function(){
    var v;
    (function(){
        if(typeof v === "undefined"){ // NOT OK
            v = 42;
        }
        for(var v in x){
        }
    });
});

const isFalsyObject = (v) => typeof v === 'undefined' && v !== undefined; // OK

function f(v) {
    if (typeof v === 'undefined' && v !== undefined) { // OK
        doSomething(v);
    }
}
