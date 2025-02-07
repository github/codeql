(function(){
    var a = null;
    a.p; // $ TODO-SPURIOUS: Alert
    a?.p;

    var b = undefined;
    b.p; // $ TODO-SPURIOUS: Alert
    b?.p;
});
