import * as _ from 'underscore';
import * as R from 'ramda';

function test() {
  if (A.endsWith(B)) {}
  if (_.endsWith(A, B)) {}
  if (R.endsWith(A, B)) {}
}
