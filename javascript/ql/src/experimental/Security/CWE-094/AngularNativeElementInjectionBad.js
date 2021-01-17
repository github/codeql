import { Directive, ElementRef, AfterViewInit, Input } from '@angular/core';

@Directive({
  selector: '[appCat]'
})
export class CatDirective implements AfterViewInit {
  @Input() altImg: string;

  constructor(
    private el: ElementRef
  ) { }

  ngAfterViewInit() {
    // BAD: this.altImg can contain malicious code that results in XSS. For example,
    // this.altImg can lead to XSS if it equaled '" onerror="alert(\'XSS Attack\')'
    this.el.nativeElement.innerHTML = '<img src="/cat.jpg" alt="' + this.altImg + '">'
  }
}
