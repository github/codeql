//codeql-extractor-options: -D BAR

// conditions and inactive branches in conditional compilation blocks are not resolved
#if FOO && os(Windows)
print(1)
#elseif BAR || arch(i386)
print(2)
#else
print(3)
#endif
