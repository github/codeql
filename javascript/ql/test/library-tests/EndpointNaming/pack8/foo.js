class Foo {} // $ name=(pack8).Foo

module.exports = Foo;
module.exports.default = Foo; // $ alias=(pack8).Foo.default==(pack8).Foo
module.exports.Foo = Foo; // $ alias=(pack8).Foo.Foo==(pack8).Foo
