export class FluentInterface {
    foo() {
        return this;
    }
    bar() {
        return this.foo();
    }
    baz() {
        return this.foo().bar().bar().foo();
    }
    notFluent() {
        this.foo();
    }
    notFluent2() {
        return this.notFluent2();
    }
}
