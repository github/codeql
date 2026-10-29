import * as rx from 'rxjs';
import * as ops from 'rxjs/operators';
import { TestScheduler } from 'rxjs/testing';
import { pluck } from "rxjs/operators/pluck";

const { of, from } = rx;
const { map, filter } = ops;

function f(){
  of(1, 2, 3).pipe(map(x => x * 2));
  someNonStream().pipe(map(x => x * 2));

  let testScheduler = new TestScheduler();
  testScheduler.run(({x, y, z}) => {
    const source = x('', {o: [a, b, c]});
    z(source.pipe(null)).toBe(expected,y,);
  });

  z.option$.pipe(pluck("x"))
}
