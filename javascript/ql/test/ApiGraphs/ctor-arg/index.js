export class A {
    constructor(x) { /* use=moduleImport("ctor-arg").getMember("exports").getMember("A").getParameter(0) */
        console.log(x);
    }
}