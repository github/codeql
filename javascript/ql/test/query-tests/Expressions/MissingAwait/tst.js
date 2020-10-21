async function getThing() {
    return something();
}

function useThing() {
    let thing = getThing();

    if (thing === undefined) {} // NOT OK

    if (thing == null) {} // NOT OK

    something(thing ? 1 : 2); // NOT OK

    for (let x in thing) { // NOT OK
        something(x);
    }

    let obj = something();
    something(obj[thing]); // NOT OK
    obj[thing] = 5; // NOT OK

    something(thing + "bar"); // NOT OK

    if (something()) {
        if (thing) { // NOT OK
            something(3);
        }
    }
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

function useThingInVoid() {
    void getThing(); // OK
}

function useThing() {
    if (random()) {
        return getThing() ?? null; // NOT OK
    } else {
        return getThing?.() ?? null; // OK
    }
}