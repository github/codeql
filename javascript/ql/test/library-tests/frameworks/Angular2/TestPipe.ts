import { Pipe, PipeTransform } from '@angular/core';

@Pipe({name: 'testPipe'})
export class TestPipe implements PipeTransform {
  transform(value: string, arg?: string): string {
    document.body.innerHTML = value;
    return value + arg;
  }
}
