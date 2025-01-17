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
    field: string = "";
    safeField: string = "";

    setInput1(event) {
        document.write(event.target.value); // NOT OK
    }

    setInput2(target) {
        document.write(target.value); // NOT OK
    }

    setOtherInput(e) {
        document.write(e.target.value); // OK
        document.write(e.value); // OK
    }

    blah(form: NgForm) {
        document.write(form.value.foo); // NOT OK
    }

    useField() {
        document.write(this.field); // NOT OK
        document.write(this.safeField); // OK
    }
}
