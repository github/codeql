function foo(x) { /* use (parameter 0 (member bar (member other (member exports (module reexport)))) */
    return x + 1;
}

export const bar = foo;