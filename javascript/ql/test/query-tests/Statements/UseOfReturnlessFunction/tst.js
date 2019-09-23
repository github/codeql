(function () {
    function stub() {
        throw new Error("Not implemented!");
    }

    function returnsValue() {
        var x = 3;
        return x * 2;
    }

    function onlySideEffects() {
        console.log("Boo!")
    }
    
    var arrow = () => onlySideEffects();

    console.log(returnsValue())
    console.log(stub())

    console.log(onlySideEffects()); // Not OK!

    var a = Math.random() > 0.5 ? returnsValue() : onlySideEffects(); // OK! A is never used.
    
    var b = onlySideEffects();
    console.log(b);
})();