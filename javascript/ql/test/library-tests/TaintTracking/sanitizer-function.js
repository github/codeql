function test() {
    function myCheck1(x) {
        return x === "a" && something() && somethingElse();
    }
    function myCheck2(x) {
        return something() && x === "a" && somethingElse();
    }
    function myCheck3(x) {
        return something() && somethingElse() && x === "a";
    }

    let taint = source();

    sink(taint); // NOT OK

    if (myCheck1(taint)) {
        sink(taint); // OK
    }

    if (myCheck2(taint)) {
        sink(taint); // OK
    }

    if (myCheck3(taint)) {
        sink(taint); // OK
    }

    function badCheck(x) {
        return something && x + isSafe(x) != null;
    }

    if (badCheck(taint)) {
        sink(taint); // NOT OK
    }
}
