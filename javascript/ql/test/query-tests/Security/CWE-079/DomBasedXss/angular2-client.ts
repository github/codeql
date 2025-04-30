import { Component, OnInit, DomSanitizer as DomSanitizer2, Renderer2, Inject } from '@angular/core';
import { ɵgetDOM } from '@angular/common';
import { ActivatedRoute, ActivatedRouteSnapshot, Router } from '@angular/router';
import { DomSanitizer } from '@angular/platform-browser';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
  title = 'my-app';

  constructor(
    private route: ActivatedRoute,
    private sanitizer: DomSanitizer,
    private router: Router,
    private sanitizer2: DomSanitizer2,
    private renderer: Renderer2,
    @Inject(DOCUMENT) private document: Document
  ) {}

  ngOnInit() {
    this.sanitizer.bypassSecurityTrustHtml(ɵgetDOM().getLocation().href); // $ Alert

    this.sanitizer.bypassSecurityTrustHtml(this.route.snapshot.params.foo); // $ Alert
    this.sanitizer.bypassSecurityTrustHtml(this.route.snapshot.queryParams.foo); // $ Alert
    this.sanitizer.bypassSecurityTrustHtml(this.route.snapshot.fragment); // $ Alert
    this.sanitizer.bypassSecurityTrustHtml(this.route.snapshot.paramMap.get('foo')); // $ Alert
    this.sanitizer.bypassSecurityTrustHtml(this.route.snapshot.queryParamMap.get('foo')); // $ Alert
    this.route.paramMap.subscribe(map => {
      this.sanitizer.bypassSecurityTrustHtml(map.get('foo')); // $ Alert
    });

    this.sanitizer.bypassSecurityTrustHtml(this.route.snapshot.url[1].path); // $ Alert - though depends on route config
    this.sanitizer.bypassSecurityTrustHtml(this.route.snapshot.url[1].parameters.x); // $ Alert
    this.sanitizer.bypassSecurityTrustHtml(this.route.snapshot.url[1].parameterMap.get('x')); // $ Alert
    this.sanitizer.bypassSecurityTrustHtml(this.route.snapshot.url[1].parameterMap.params.x); // $ Alert

    this.sanitizer.bypassSecurityTrustHtml(this.router.url); // $ Alert

    this.sanitizer2.bypassSecurityTrustHtml(this.router.url); // $ Alert
    this.renderer.setProperty(this.document.documentElement, 'innerHTML', this.route.snapshot.queryParams.foo); // $ Alert
  }

  someMethod(routeSnapshot: ActivatedRouteSnapshot) {
    this.sanitizer.bypassSecurityTrustHtml(routeSnapshot.paramMap.get('foo')); // $ Alert
  }
}
