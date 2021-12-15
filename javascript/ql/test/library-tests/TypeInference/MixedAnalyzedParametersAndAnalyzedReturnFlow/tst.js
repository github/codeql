(function(){
    function getKnown() { return true; }

    function getUnknown() { return UNKNOWN; }

    f(true, UNKNOWN, getKnown(), getUnknown(), getKnown, getUnknown);

    function f(known, unknown, gotKnown, gotUnknown, getKnown_indirect, getUnknown_indirect) {
        DUMP(getKnown(), getUnknown());
        DUMP(getKnown_indirect, getUnknown_indirect);
        DUMP(known, unknown, gotKnown, gotUnknown, getKnown_indirect(), getUnknown_indirect())
    }
});
