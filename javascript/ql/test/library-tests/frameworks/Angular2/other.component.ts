import { Component } from "@angular/core";
import { DomSanitizer } from '@angular/platform-browser';

@Component({
    selector: "other-component",
    template: "not important"
})
export class OtherComponent {
    prop1: string;
    prop2: string;
    prop3: string;
    prop4: string;
    prop5: string;

    constructor(private sanitizer: DomSanitizer) {}

    foo() {
        this.sanitizer.bypassSecurityTrustHtml(this.prop1);
        this.sanitizer.bypassSecurityTrustHtml(this.prop2);
        this.sanitizer.bypassSecurityTrustHtml(this.prop3);
        this.sanitizer.bypassSecurityTrustHtml(this.prop4);
        this.sanitizer.bypassSecurityTrustHtml(this.prop5);
    }
}
