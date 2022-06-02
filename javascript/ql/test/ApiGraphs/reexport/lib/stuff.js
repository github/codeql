function foo(x) { /* use=moduleImport("reexport").getMember("exports").getMember("other").getMember("bar").getParameter(0) */
    return x + 1;
}

export const bar = foo;