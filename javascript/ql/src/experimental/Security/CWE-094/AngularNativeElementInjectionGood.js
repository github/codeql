import { Directive, AfterViewInit, Input, Renderer2 } from '@angular/core';

@Directive({
  selector: '[appCat]'
})
export class CatDirective implements AfterViewInit {
  @Input() altImg: string;

  constructor(
    private renderer: Renderer2
  ) { }

  ngAfterViewInit() {
    const img = this.renderer.createElement('img');
    this.renderer.setAttribute(img, 'src', '/cat.jpg');
    this.renderer.setAttribute(img, 'alt', this.altImg);

    // GOOD: Utilizing Renderer2 ensures that any input is properly sanitized.
    this.renderer.appendChild(this.el.nativeElement, img);
  }
}
