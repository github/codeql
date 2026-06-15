async function getThing() {
    return something();
}

function useThing() {
    let thing = getThing();

    if (thing === undefined) {} // $ Alert

    if (thing == null) {} // $ Alert

    something(thing ? 1 : 2); // $ Alert

    for (let x in thing) { // $ Alert
        something(x);
    }

    let obj = something();
    something(obj[thing]); // $ Alert
    obj[thing] = 5; // $ Alert

    something(thing + "bar"); // $ Alert

    if (something()) {
        if (thing) { // $ Alert
            something(3);
        }
    }
}

async function useThingCorrectly() {
    let thing = await getThing();

    if (thing === undefined) {}

    if (thing == null) {}

    return thing + "bar";
}

async function useThingCorrectly2() {
    let thing = getThing();

    if (await thing === undefined) {}

    if (await thing == null) {}

    return thing + "bar"; // $ Alert
}

function getThingSync() {
    return something();
}

function useThingPossiblySync(b) {
    let thing = b ? getThing() : getThingSync();

    if (thing === undefined) {}

    if (thing == null) {}

    return thing + "bar"; // $ MISSING: Alert
}

function useThingInVoid() {
    void getThing();
}

function useThing() {
    if (random()) {
        return getThing() ?? null; // $ Alert
    } else {
        return getThing?.() ?? null;
    }
}
