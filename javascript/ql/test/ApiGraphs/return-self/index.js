export class A {
    foo() {
        return this; /* def=moduleImport("return-self").getMember("exports").getMember("A").getInstance().getMember("foo").getReturn() */
    }
    bar(x) { } /* use=moduleImport("return-self").getMember("exports").getMember("A").getInstance().getMember("bar").getParameter(0) */
}
