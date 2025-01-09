import { Component } from "@angular/core";
import { NgForm } from "@angular/forms";

@Component({
    template: `
        <input type="text" (input)="setInput1($event)"></input>
        <input type="text" (input)="setInput2($event.target)"></input>
    `
})
export class Foo {
    setInput1(event) {
        document.write(event.target.value); // NOT OK
    }

    setInput2(target) {
        document.write(target.value); // NOT OK
    }

    blah(form: NgForm) {
        document.write(form.value.foo); // NOT OK
    }
}
