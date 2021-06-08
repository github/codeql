import { Component } from "@angular/core";

@Component({
	template: `
	<foo [prop]="expr + expr"/>
	<foo [baz]="expr!" />
	<foo [baz]="expr?.bar" />
	`
})
export class MyComponent {}
