function f(a) {
  const [a,  // OK: used
	     _,  // OK: starts with underscore
	     _c, // OK: starts with underscore
	     d,  // OK: used
	     e,  // NOT OK
	     f]  // NOT OK
         = a;
  return a + d;
}
