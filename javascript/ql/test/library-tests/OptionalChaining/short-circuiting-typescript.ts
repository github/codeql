(function() {
    var o1 = {};
    x?.(o1 = null);
    DUMP(o1);

    var o2 = {};
    x?.[o2 = null];
    DUMP(o2);

    var o3 = {},
        o4 = {};
    x?.[o3 = null]?.(o4 = null);
    DUMP(o3);
    DUMP(o4);
});
