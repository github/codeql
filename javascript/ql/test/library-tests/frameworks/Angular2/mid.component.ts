import { Input, Component } from '@angular/core';

@Component({
    selector: 'mid-component',
    templateUrl: './mid.component.html'
})
export class MidComponent {
    @Input() field: string;
}
