import { Input, Component } from '@angular/core';

@Component({
    selector: 'mid-component',
    template: `
        <sink-component [sink7]="taint"></sink-component>

        \n<sink-component [sink9]="taint" [testAttr]="taint"></sink-component>
`
})
export class InlineComponent {
    taint: string;

    constructor() {
        this.taint = source();
    }
}
