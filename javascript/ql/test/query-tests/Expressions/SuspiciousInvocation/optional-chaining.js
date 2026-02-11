(function(){
    var a = null;
    a(); // $ Alert
    a?.();

    var b = undefined;
    b(); // $ Alert
    b?.();
});
