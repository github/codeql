function u1() {
    const searchParams = new URLSearchParams(source("u1.1"));
    sink(searchParams.get("x")); // $ hasTaintFlow=u1.1
    sink(searchParams.get(unknown())); // $ hasTaintFlow=u1.1
    sink(searchParams.getAll("x")); // $ hasTaintFlow=u1.1
    sink(searchParams.getAll(unknown())); // $ hasTaintFlow=u1.1
}

function u2() {
    const url = new URL(source("u2.1"));
    sink(url.searchParams.get("x")); // $ hasTaintFlow=u2.1
    sink(url.searchParams.get(unknown())); // $ hasTaintFlow=u2.1
    sink(url.searchParams.getAll("x")); // $ hasTaintFlow=u2.1
    sink(url.searchParams.getAll(unknown())); // $ hasTaintFlow=u2.1
}
