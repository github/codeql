//codeql-extractor-options: -enable-experimental-feature ValueGenerics -disable-availability-checking

struct A<let N: Int> {
    var x = N;
}

func f(with a : A<128>) {}

func g(with a : A<256>) {}
