import * as _ from 'lodash';
let strings = goog.require('goog.string');

function test() {
  if (A.includes(B)) {}
  if (_.includes(A, B)) {}
  if (A.indexOf(B) !== -1) {}
  if (A.indexOf(B) >= 0) {}
  if (~A.indexOf(B)) {}
  
  // negated
  if (A.indexOf(B) === -1) {}
  if (A.indexOf(B) < 0) {}
  
  // non-examples
  if (A.indexOf(B) === 0) {}
  if (A.indexOf(B) !== 0) {}
  if (A.indexOf(B) > 0) {}
  
  if (strings.contains(A, B)) {}
  if (strings.caseInsensitiveContains(A, B)) {}
}
