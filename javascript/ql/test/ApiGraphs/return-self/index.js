export class A {
    foo() {
        return this; /* def (return (member foo (instance (member A (member exports (module return-self)))))) */
    }
    bar(x) { } /* use (parameter 0 (member bar (instance (member A (member exports (module return-self)))))) */
}
