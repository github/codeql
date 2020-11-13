import { Component, OnInit } from '@angular/core';
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
    private router: Router
  ) {}

  ngOnInit() {
    this.sanitizer.bypassSecurityTrustHtml(ɵgetDOM().getLocation().href); // NOT OK

    this.sanitizer.bypassSecurityTrustHtml(this.route.snapshot.params.foo); // NOT OK
    this.sanitizer.bypassSecurityTrustHtml(this.route.snapshot.queryParams.foo); // NOT OK
    this.sanitizer.bypassSecurityTrustHtml(this.route.snapshot.fragment); // NOT OK
    this.sanitizer.bypassSecurityTrustHtml(this.route.snapshot.paramMap.get('foo')); // NOT OK
    this.sanitizer.bypassSecurityTrustHtml(this.route.snapshot.queryParamMap.get('foo')); // NOT OK
    this.route.paramMap.subscribe(map => {
      this.sanitizer.bypassSecurityTrustHtml(map.get('foo')); // NOT OK
    });

    this.sanitizer.bypassSecurityTrustHtml(this.route.snapshot.url[1].path); // NOT OK - though depends on route config
    this.sanitizer.bypassSecurityTrustHtml(this.route.snapshot.url[1].parameters.x); // NOT OK
    this.sanitizer.bypassSecurityTrustHtml(this.route.snapshot.url[1].parameterMap.get('x')); // NOT OK
    this.sanitizer.bypassSecurityTrustHtml(this.route.snapshot.url[1].parameterMap.params.x); // NOT OK

    this.sanitizer.bypassSecurityTrustHtml(this.router.url); // NOT OK
  }

  someMethod(routeSnapshot: ActivatedRouteSnapshot) {
    this.sanitizer.bypassSecurityTrustHtml(routeSnapshot.paramMap.get('foo')); // NOT OK
  }
}
