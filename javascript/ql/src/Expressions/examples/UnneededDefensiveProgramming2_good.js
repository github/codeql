function setSafeStringProp(o, prop, v) {
    // GOOD: `v == undefined` handles both `undefined` and `null`
    var safe = v == undefined? '': v;
    o[prop] = safe;
}
