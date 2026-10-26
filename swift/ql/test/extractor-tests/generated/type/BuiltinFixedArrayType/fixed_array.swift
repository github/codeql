//codeql-extractor-options: -enable-experimental-feature BuiltinModule -enable-experimental-feature ValueGenerics -disable-availability-checking

import Builtin

struct A<let N: Int, T: AnyObject> {
    var x: Builtin.FixedArray<N, T>
}

func f(x: Builtin.FixedArray<4, Int>) {}
