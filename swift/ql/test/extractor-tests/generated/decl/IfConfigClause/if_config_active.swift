//codeql-extractor-options: -D FOO

#if FOO
var foo: Int = 1
print("foo")
#elseif os(macOS)
var bar: Int = 2
print("bar")
#else
var baz: Int = 3
print("baz")
#endif
