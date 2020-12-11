import { Component } from "@angular/core";

@Component({
    selector: "foo-component",
    templateUrl: "./foo.component.html"
})
export class Foo {
    foo: string;
    taintedArray: string[];
    safeArray: string[];

    constructor() {
        this.foo = source();
        this.taintedArray = [...source()];
        this.safeArray = ['a', 'b'];
    }
}
