// OK: `const` is block scoped in ECMAScript 2015
function f() {
    {
        const val = 1;
    }

    {
        const val = 2;
    }
}
