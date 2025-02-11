(function(){
    var a = null;
    a(); // $ TODO-SPURIOUS: Alert
    a?.();

    var b = undefined;
    b(); // $ TODO-SPURIOUS: Alert
    b?.();
});
