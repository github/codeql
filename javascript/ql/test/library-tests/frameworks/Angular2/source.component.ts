import { Component } from "@angular/core";

@Component({
    selector: "source-component",
    templateUrl: "./source.component.html"
})
export class Source {
    taint: string;
    taintedArray: string[];
    safeArray: string[];

    constructor() {
        this.taint = source();
        this.taintedArray = [...source()];
        this.safeArray = ['a', 'b'];
    }
}
