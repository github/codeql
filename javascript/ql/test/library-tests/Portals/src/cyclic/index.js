function foo(cb) {
  cb(foo);
  return foo;
}
foo.f00 = foo;

foo(foo);
foo(foo());

exports.foo = foo;
