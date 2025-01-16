import 'dummy';

async function test1() {
    let mod = await import("./export-taint");
    sink(mod); // OK
    sink(mod.taint); // NOT OK
    sink(mod.object.taint); // NOT OK [INCONSISTENCY] - blocked by access path limit
}

function test2() {
    import("./export-taint").then(mod => {
        sink(mod); // OK
        sink(mod.taint); // NOT OK
        sink(mod.object.taint); // NOT OK [INCONSISTENCY] - blocked by access path limit
    });
}
