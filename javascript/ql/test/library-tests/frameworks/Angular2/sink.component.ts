import { Component } from "@angular/core";
import { DomSanitizer } from '@angular/platform-browser';

@Component({
    selector: "sink-component",
    template: "not important"
})
export class SinkComponent {
    sink1: string;
    sink2: string;
    sink3: string;
    sink4: string;
    sink5: string;
    sink6: string;
    sink7: string;
    sink8: string;
    sink9: string;

    constructor(private sanitizer: DomSanitizer) {}

    foo() {
        this.sanitizer.bypassSecurityTrustHtml(this.sink1);
        this.sanitizer.bypassSecurityTrustHtml(this.sink2);
        this.sanitizer.bypassSecurityTrustHtml(this.sink3);
        this.sanitizer.bypassSecurityTrustHtml(this.sink4);
        this.sanitizer.bypassSecurityTrustHtml(this.sink5);
        this.sanitizer.bypassSecurityTrustHtml(this.sink6);
        this.sanitizer.bypassSecurityTrustHtml(this.sink7);
        this.sanitizer.bypassSecurityTrustHtml(this.sink8);
        this.sanitizer.bypassSecurityTrustHtml(this.sink9);
    }
}
