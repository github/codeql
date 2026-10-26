class Foo {
}

Foo.prototype.bar = 23;

(function() {
    class LocalFoo {
    }

    LocalFoo.prototype.bar = 42;
});