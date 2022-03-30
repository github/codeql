function setSafeStringProp(o, prop, v) {
    // BAD: `v == null` is useless
    var safe = v == undefined || v == null? '': v;
    o[prop] = safe;
}
