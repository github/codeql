import { Component } from "@angular/core";
import { DomSanitizer } from '@angular/platform-browser';

@Component({
    selector: "source-component",
    templateUrl: "./source.component.html"
})
export class Source {
    taint: string;
    taintedArray: string[];
    safeArray: string[];

    constructor(private sanitizer: DomSanitizer) {
        this.taint = source();
        this.taintedArray = [...source()];
        this.safeArray = ['a', 'b'];
    }

    methodOnComponent(x) {
        this.sanitizer.bypassSecurityTrustHtml(x);
    }
}
