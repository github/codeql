import T from 'somewhere'; // NOT OK: `T` is unused (it is shadowed by another T)
import object from 'somewhere'; // NOT OK: `object` is unused (it is "shadowed" by a keyword)
import * as N from 'somewhere'; // OK: N is a namespace and thus not shadowed by 'interface N'.

{
  var x: T = {};
  console.log(x);
  
  interface T {}
  
  var z: object = null;
  console.log(z)
  
  interface N {} // unused (but not checked by this query)
  
  var w: N.T = null;
  console.log(w)
}
