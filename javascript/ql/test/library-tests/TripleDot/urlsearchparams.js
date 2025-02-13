function u1() {
    const searchParams = new URLSearchParams(source("u1.1"));
    sink(searchParams.get("x")); // $ MISSING: hasTaintFlow=u1.1
    sink(searchParams.get(unknown())); // $ MISSING: hasTaintFlow=u1.1
    sink(searchParams.getAll("x")); // $ MISSING: hasTaintFlow=u1.1
    sink(searchParams.getAll(unknown())); // $ MISSING: hasTaintFlow=u1.1
}

function u2() {
    const url = new URL(source("u2.1"));
    sink(url.searchParams.get("x")); // $ MISSING: hasTaintFlow=u2.1
    sink(url.searchParams.get(unknown())); // $ MISSING: hasTaintFlow=u2.1
    sink(url.searchParams.getAll("x")); // $ MISSING: hasTaintFlow=u2.1
    sink(url.searchParams.getAll(unknown())); // $ MISSING: hasTaintFlow=u2.1
}
