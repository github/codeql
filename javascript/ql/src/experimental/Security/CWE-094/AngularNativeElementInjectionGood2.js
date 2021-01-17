import { Directive, ElementRef, AfterViewInit, Input, DomSanitizer, SecurityContext } from '@angular/core';

@Directive({
  selector: '[appCat]'
})

export class CatDirective implements AfterViewInit {
  @Input() altImg: string;

  constructor(
    private el: ElementRef,
    private sanitizer: DomSanitizer
  ) { }

  ngAfterViewInit() {
    var sanitizedAltImg = this.sanitizer.sanitize(SecurityContext.HTML, this.altImg)

    // GOOD: this.altImg is properly sanitized.
    this.el.nativeElement.innerHTML = '<img src="/cat.jpg" alt="' + sanitizedAltImg + '">'
  }
}
