import { Component } from "@angular/core";

@Component({
    selector: "foo-component",
    templateUrl: "./foo.component.html"
})
export class Foo {
    foo: string;

    constructor() {
        this.foo = source();
    }
}
