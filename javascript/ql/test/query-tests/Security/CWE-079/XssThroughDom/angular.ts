import { Component } from "@angular/core";
import { NgForm } from "@angular/forms";

@Component({
    template: `
        <input type="text" (input)="setInput1($event)"></input>
        <input type="text" (input)="setInput2($event.target)"></input>
        <input type="text" [(ngModel)]="field"></input>
    `
})
export class Foo {
    field: string = ""; // $ Source
    safeField: string = "";

    setInput1(event) {
        document.write(event.target.value); // $ Alert
    }

    setInput2(target) {
        document.write(target.value); // $ Alert
    }

    setOtherInput(e) {
        document.write(e.target.value);
        document.write(e.value);
    }

    blah(form: NgForm) {
        document.write(form.value.foo); // $ Alert
    }

    useField() {
        document.write(this.field); // $ Alert
        document.write(this.safeField);
    }
}
