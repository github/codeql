import { foo, bar as baz } from 'foobar';

console.log(
  foo +
  bar +
  baz +
  quux
);

import { quux } from 'outside';

f();
g();

export function f() {};
export default function g() {};