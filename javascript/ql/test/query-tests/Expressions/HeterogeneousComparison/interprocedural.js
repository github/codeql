(function(){

    function getUnknown() { return UNKNOWN; }

    function getKnown() { return "foo"; }

    function f(known, unknown, gotKnown, gotUnknown, getKnown_indirect, getUnknown_indirect) {
        // disable the whitelist
        known = known; unknown = unknown; gotKnown = gotKnown; gotUnknown = gotUnknown;

        known === 42;
        known == 42;
        gotKnown === 42;
        gotKnown == 42;
        getKnown() === 42;
        getKnown() == 42;
        getKnown_indirect() === 42;
        getKnown_indirect() == 42;

        unknown === 42;
        unknown == 42;
        gotUnknown === 42;
        gotUnknown == 42;
        getUnknown() === 42;
        getUnknown() == 42;
        getUnknown_indirect() === 42;
        getUnknown_indirect() == 42;
    }

    f("foo", UNKNOWN, getKnown(), getUnknown(), getKnown, getUnknown);

});
