import { Component, Input } from "@angular/core";
import { DomSanitizer } from '@angular/platform-browser';

@Component({
    selector: "sink-component",
    template: "not important"
})
export class SinkComponent {
    @Input() sink1: string;
    @Input() sink2: string;
    @Input() sink3: string;
    @Input() sink4: string;
    @Input() sink5: string;
    @Input() sink6: string;
    @Input() sink7: string;
    @Input() sink8: string;
    @Input() sink9: string;

    constructor(private sanitizer: DomSanitizer) { }

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
