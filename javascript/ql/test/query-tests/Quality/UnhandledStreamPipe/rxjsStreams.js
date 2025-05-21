import * as rx from 'rxjs';
import * as ops from 'rxjs/operators';

const { of, from } = rx;
const { map, filter } = ops;

function f(){
  of(1, 2, 3).pipe(map(x => x * 2)); // $SPURIOUS:Alert
  someNonStream().pipe(map(x => x * 2)); // $SPURIOUS:Alert
}
