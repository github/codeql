class Foo {
    fun foo(): Foo { return this }

    fun bar(x: Foo?): Foo? {
        return x?.foo()
    }
}
