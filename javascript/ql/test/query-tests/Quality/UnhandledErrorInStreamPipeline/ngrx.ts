import { Component } from '@angular/core';
import { Store, select } from '@ngrx/store';
import { Observable } from 'rxjs';

@Component({
  selector: 'minimal-example',
  template: `
    <div>{{ value$ | async }}</div>
  `
})
export class MinimalExampleComponent {
  value$: Observable<any>;

  constructor(private store: Store<any>) {
    this.value$ = this.store.pipe(select('someSlice'));
  }
}
