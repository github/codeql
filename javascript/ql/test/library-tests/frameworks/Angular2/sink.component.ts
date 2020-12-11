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

    constructor(private sanitizer: DomSanitizer) {}

    foo() {
        this.sanitizer.bypassSecurityTrustHtml(this.sink1);
        this.sanitizer.bypassSecurityTrustHtml(this.sink2);
        this.sanitizer.bypassSecurityTrustHtml(this.sink3);
        this.sanitizer.bypassSecurityTrustHtml(this.sink4);
        this.sanitizer.bypassSecurityTrustHtml(this.sink5);
    }
}
