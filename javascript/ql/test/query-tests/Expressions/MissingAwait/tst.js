async function getThing() {
    return something();
}

function useThing() {
    let thing = getThing();

    if (thing === undefined) {} // NOT OK

    if (thing == null) {} // NOT OK

    return thing + "bar"; // NOT OK
}

async function useThingCorrectly() {
    let thing = await getThing();

    if (thing === undefined) {} // OK

    if (thing == null) {} // OK

    return thing + "bar"; // OK
}

async function useThingCorrectly2() {
    let thing = getThing();

    if (await thing === undefined) {} // OK

    if (await thing == null) {} // OK

    return thing + "bar"; // NOT OK
}

function getThingSync() {
    return something();
}

function useThingPossiblySync(b) {
    let thing = b ? getThing() : getThingSync();

    if (thing === undefined) {} // OK

    if (thing == null) {} // OK

    return thing + "bar"; // NOT OK - but we don't flag it
}
