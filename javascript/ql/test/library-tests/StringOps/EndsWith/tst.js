import * as _ from 'underscore';
import * as R from 'ramda';
let strings = goog.require('goog.string');

function test() {
  if (A.endsWith(B)) {}
  if (_.endsWith(A, B)) {}
  if (R.endsWith(A, B)) {}
  if (strings.endsWith(A, B)) {}
  if (strings.caseInsensitiveEndsWith(A, B)) {}
}
