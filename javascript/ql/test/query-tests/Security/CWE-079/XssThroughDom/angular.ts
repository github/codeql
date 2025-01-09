import { Component } from "@angular/core";

@Component({
    template: `
        <input type="text" (input)="setInput1($event)"></input>
        <input type="text" (input)="setInput2($event.target)"></input>
    `
})
export class Foo {
    setInput1(event) {
        document.write(event.target.value); // NOT OK [INCONSISTENCY]
    }

    setInput2(target) {
        document.write(target.value); // NOT OK [INCONSISTENCY]
    }
}
