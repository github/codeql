(function(){
    var v;
    (function(){
        if(typeof v === "undefined"){ // $ Alert[js/unneeded-defensive-code]
            v = 42;
        }
        for(var v in x){
        }
    });
});

const isFalsyObject = (v) => typeof v === 'undefined' && v !== undefined;

function f(v) {
    if (typeof v === 'undefined' && v !== undefined) {
        doSomething(v);
    }
}
