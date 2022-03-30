(function(){
    var o = {};
    o.prop1 = o['prop1'] = x;

    o['prop2'] = o.prop2 = x;

    o.prop3 = x
    o['prop3'] = x;

    o['prop4'] = x;
    o.prop4 = x
});
