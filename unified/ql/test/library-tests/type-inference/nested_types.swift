class Base<TBase> {
    let baseValue: TBase

    init(baseValue: TBase) {
        self.baseValue = baseValue  // $ field=Base.baseValue
    }

    func getBase() -> TBase {
        return self.baseValue  // $ field=Base.baseValue
    }
}

class Outer<TOuter> {
    class Inner<TInner>: Base<TInner> {
        let innerValue: TInner
        let outerValue: TOuter

        init(innerValue: TInner, outerValue: TOuter) {
            self.innerValue = innerValue  // $ field=Outer.Inner.innerValue
            self.outerValue = outerValue  // $ field=Outer.Inner.outerValue
            super.init(baseValue: innerValue)  // $ target=Base.init
        }

        convenience init(innerValue: TInner) {  // name=Outer.Inner.init_conv
            fatalError("Convenience initializer not implemented")
        }

        func getInner() -> TInner {
            return self.innerValue  // $ field=Outer.Inner.innerValue
        }

        func getOuter() -> TOuter {
            return self.outerValue  // $ field=Outer.Inner.outerValue
        }

        func swap() -> Outer<TInner>.Inner<TOuter> {
            return Outer<TInner>.Inner(innerValue: self.outerValue, outerValue: self.innerValue)  // $ field=Outer.Inner.innerValue field=Outer.Inner.outerValue target=Outer.Inner.init $ SPURIOUS: target=Outer.Inner.init_conv
        }

        func getSelf1() -> Inner<TInner> {
            return self
        }

        func getSelf2() -> Inner {
            return self
        }
    }

    class SubInner<TSubInner>: Inner<TSubInner> {}

    static func createInner(outerValue: TOuter) -> Inner<Int> {
        return Inner(innerValue: 0, outerValue: outerValue)  // $ target=Outer.Inner.init $ SPURIOUS: target=Outer.Inner.init_conv
    }

    typealias InnerAlias = Inner

    typealias IntInner = Inner<Int>

    func f(_ x: Outer<String>.IntInner) {}

    typealias Fixed = Outer<Int>.Inner<String>

    func f(_ y: Fixed, _ z: Outer<Bool>.Fixed) {
        let outer = z.getOuter()  // $ target=Outer.Inner.getOuter type=outer:Int
        let inner = z.getInner()  // $ target=Outer.Inner.getInner type=inner:String
    }

    class Holder {
        typealias InnerAlias = Inner
    }

    class Holder2<T> {
        typealias InnerAlias = Inner
    }

    func f(
        z: Outer<String>.Holder.InnerAlias<Bool>,
        y: Outer<String>.Holder2<Int>.InnerAlias<Bool>
    ) {
        let a = z.getInner()  // $ target=Outer.Inner.getInner type=a:Bool
        let b = z.getOuter()  // $ target=Outer.Inner.getOuter type=b:String
        let c = y.getInner()  // $ target=Outer.Inner.getInner type=c:Bool
        let d = y.getOuter()  // $ target=Outer.Inner.getOuter type=d:String
    }

    typealias Fixed2 = Identity<Outer<String>.IntInner>

    func f(f1: Fixed2, f2: Outer<Bool>.Fixed2) {
        let a = f1.getInner()  // $ target=Outer.Inner.getInner type=a:Int
        let b = f1.getOuter()  // $ target=Outer.Inner.getOuter type=b:String
        let c = f2.getInner()  // $ target=Outer.Inner.getInner type=c:Int
        let d = f2.getOuter()  // $ target=Outer.Inner.getOuter type=d:String
    }

    typealias Captured = Outer<TOuter>.Inner<Int>

    func f(x: Outer<String>.Captured) {
        let outer = x.getOuter()  // $ target=Outer.Inner.getOuter type=outer:String
        let inner = x.getInner()  // $ target=Outer.Inner.getInner type=inner:Int
    }

    typealias Rebound = Identity<Identity<Inner<Int>>>

    func f2(x: Outer<String>.Rebound) {
        let outer = x.getOuter()  // $ target=Outer.Inner.getOuter type=outer:String
        let inner = x.getInner()  // $ target=Outer.Inner.getInner type=inner:Int
    }

    typealias Pair = (Inner<Int>, Inner<Int>)

    func f3(p1: Pair, p2: Outer<Bool>.Pair) {
        let a = p1.0.getOuter()  // $ target=Outer.Inner.getOuter field=Tuple2.0 type=a:TOuter
        let b = p1.0.getInner()  // $ target=Outer.Inner.getInner field=Tuple2.0 type=b:Int
        let c = p2.0.getOuter()  // $ target=Outer.Inner.getOuter field=Tuple2.0 type=c:Bool
        let d = p2.0.getInner()  // $ target=Outer.Inner.getInner field=Tuple2.0 type=d:Int
    }

    typealias Unbound = Holder.InnerAlias

    func f4(x: Outer<String>.Unbound<Int>) {
        let outer = x.getOuter()  // $ target=Outer.Inner.getOuter type=outer:String
        let inner = x.getInner()  // $ target=Outer.Inner.getInner type=inner:Int
    }

    enum E { case empty }

    typealias X = TOuter

    class Derived: Outer<Int> {}
}

let e: Outer<Int>.E = Outer.E.empty  // $ field=Outer.E.empty type=.empty@Outer.E<(parent:E)>.Outer<TOuter>:Int

func f(x: Outer<String>.Derived.X) {}  // $ type=x:Int $ SPURIOUS: type=x:String

class Foo: Outer<String> {
    func f(x: Pair, y: Outer<Bool>.Pair) {
        var a = x.0.getInner()  // $ target=Outer.Inner.getInner field=Tuple2.0 type=a:Int
        var b = x.0.getOuter()  // $ target=Outer.Inner.getOuter field=Tuple2.0 type=b:String
        var c = y.0.getInner()  // $ target=Outer.Inner.getInner field=Tuple2.0 type=c:Int
        var d = y.0.getOuter()  // $ target=Outer.Inner.getOuter field=Tuple2.0
    }
}

func extractInner<Ta, Tb>(_ inner: Outer<Ta>.Inner<Tb>) -> Tb {
    return inner.getInner()  // $ target=Outer.Inner.getInner
}

func extractOuter<Ta, Tb>(_ inner: Outer<Ta>.Inner<Tb>) -> Ta {
    return inner.getOuter()  // $ target=Outer.Inner.getOuter
}

var inner1 = Outer.Inner(innerValue: 42, outerValue: "")  // $ target=Outer.Inner.init $ SPURIOUS: target=Outer.Inner.init_conv
var x1a = inner1.getInner()  // $ type=x1a:Int target=Outer.Inner.getInner
var x1b = extractInner(inner1)  // $ type=x1b:Int target=extractInner
var y1a = inner1.getOuter()  // $ type=y1a:String target=Outer.Inner.getOuter
var y1b = extractOuter(inner1)  // $ type=y1b:String target=extractOuter
var b1 = inner1.getBase()  // $ type=b1:Int target=Base.getBase

var inner2 = Outer<String>.Inner(innerValue: 42)  // $ target=Outer.Inner.init_conv $ SPURIOUS: target=Outer.Inner.init
var x2a = inner2.getInner()  // $ type=x2a:Int target=Outer.Inner.getInner
var x2b = extractInner(inner2)  // $ type=x2b:Int target=extractInner
var y2a = inner2.getOuter()  // $ type=y2a:String target=Outer.Inner.getOuter
let y2b = extractOuter(inner2)  // $ type=y2b:String target=extractOuter
var b2 = inner2.getBase()  // $ type=b2:Int target=Base.getBase

var swapped = inner1.swap()  // $ target=Outer.Inner.swap
var x3 = swapped.getInner()  // $ type=x3:String target=Outer.Inner.getInner
var y3 = swapped.getOuter()  // $ type=y3:Int target=Outer.Inner.getOuter
var b3 = swapped.getBase()  // $ type=b3:String target=Base.getBase

var inner4 = inner1.getSelf1()  // $ target=Outer.Inner.getSelf1
var x4 = inner4.getInner()  // $ type=x4:Int target=Outer.Inner.getInner
var y4 = inner4.getOuter()  // $ type=y4:String target=Outer.Inner.getOuter
var b4 = inner4.getBase()  // $ type=b4:Int target=Base.getBase

var inner5 = inner1.getSelf2()  // $ target=Outer.Inner.getSelf2
var x5 = inner5.getInner()  // $ type=x5:Int target=Outer.Inner.getInner
var y5 = inner5.getOuter()  // $ type=y5:String target=Outer.Inner.getOuter
var b5 = inner5.getBase()  // $ type=b5:Int target=Base.getBase

var inner6 = Outer.createInner(outerValue: false)  // $ target=Outer.createInner
var x6 = inner6.getInner()  // $ type=x6:Int target=Outer.Inner.getInner
var y6 = inner6.getOuter()  // $ type=y6:Bool target=Outer.Inner.getOuter
var b6 = inner6.getBase()  // $ type=b6:Int target=Base.getBase

var inner7 = Outer.InnerAlias(innerValue: 0, outerValue: false)  // $ target=Outer.Inner.init $ SPURIOUS: target=Outer.Inner.init_conv
var x11 = inner7.getInner()  // $ type=x11:Int target=Outer.Inner.getInner
var y11 = inner7.getOuter()  // $ type=y11:Bool target=Outer.Inner.getOuter

extension Outer.Inner {
    class InnerMost {
        var x: TOuter
        var y: TInner

        init(x: TOuter, y: TInner) {
            self.x = x  // $ field=Outer.Inner.InnerMost.x
            self.y = y  // $ field=Outer.Inner.InnerMost.y
        }

        func getOuter() -> TOuter {
            return self.x  // $ field=Outer.Inner.InnerMost.x
        }

        func getInner() -> TInner {
            return self.y  // $ field=Outer.Inner.InnerMost.y
        }
    }
}

var innerMost = Outer.Inner.InnerMost(x: "", y: 42)  // $ target=Outer.Inner.InnerMost.init
var x7 = innerMost.getInner()  // $ target=Outer.Inner.InnerMost.getInner $ MISSING: type=x7:Int (https://github.com/github/codeql-team/issues/4968)
var y7 = innerMost.getOuter()  // $ target=Outer.Inner.InnerMost.getOuter $ MISSING: type=y7:String (https://github.com/github/codeql-team/issues/4968)

class SubOuter<TSubOuter>: Outer<[TSubOuter]> {
    func f(_ x: Inner<String>) -> [TSubOuter] {
        let res = x.getOuter()  // $ target=Outer.Inner.getOuter $ MISSING: type=res@Array<Element>:TSubOuter -- this is an instance of variance sub typing
        return res
    }
}

var subOuter = SubOuter<Int>.createInner(outerValue: [42])  // $ target=Outer.createInner
var x8 = subOuter.getInner()  // $ type=x8:Int target=Outer.Inner.getInner
var y8 = subOuter.getOuter()  // $ type=y8@Array<Element>:Int target=Outer.Inner.getOuter

var subInner = Outer.SubInner(innerValue: true, outerValue: 0)  // $ target=Outer.Inner.init $ SPURIOUS: target=Outer.Inner.init_conv
var x9 = subInner.getInner()  // $ type=x9:Bool target=Outer.Inner.getInner
var y9 = subInner.getOuter()  // $ type=y9:Int target=Outer.Inner.getOuter

let subInner2: Outer<String>.SubInner<Int> = Outer.SubInner(innerValue: 1)  // $ target=Outer.Inner.init_conv $ SPURIOUS: target=Outer.Inner.init
let x12 = subInner2.getInner()  // $ target=Outer.Inner.getInner type=x12:Int
let y12 = subInner2.getOuter()  // $ target=Outer.Inner.getOuter type=y12:String

class SubInnerOutside<TSubInner>: Outer<TSubInner>.Inner<TSubInner> {}

var subInnerOutside = SubInnerOutside(innerValue: true, outerValue: false)  // $ target=Outer.Inner.init $ SPURIOUS: target=Outer.Inner.init_conv
var x10 = subInnerOutside.getInner()  // $ type=x10:Bool target=Outer.Inner.getInner
var y10 = subInnerOutside.getOuter()  // $ type=y10:Bool target=Outer.Inner.getOuter

class Node {
    class Mid {
        class Leaf: Node {
            let x: Leaf = Leaf()  // $ type=x@Node.Mid.Leaf<(parent:Leaf)>:Node.Mid target=Node.init
            let y: Mid = Mid()  // $ type=y@Node.Mid<(parent:Mid)>:Node target=Node.Mid.init
        }
    }
}

class Holder { typealias Fixed = Outer<Int>.Inner }

let holder = Holder.Fixed(innerValue: "")  // $ target=Outer.Inner.init_conv $ SPURIOUS: target=Outer.Inner.init
let x13 = holder.getInner()  // $ target=Outer.Inner.getInner type=x13:String
let y13 = holder.getOuter()  // $ target=Outer.Inner.getOuter type=y13:Int

class Box<T> {
    typealias IntBox = Box<Int>

    typealias Same = Box

    typealias X = T

    func f(
        _ x: IntBox,
        _ y: Box<Int>.Same,  // $ type=y@Box<T>:Int
        _ z: X  // $ type=z:T
    ) {}
}

class SubBox<S>: Box<S?> {}

class SubSubBox: SubBox<Int> {}

let i: SubSubBox.X  // $ type=i@Optional<Wrapped>:Int

let a: [SubSubBox.X]  // $ type=a@Array<Element>.Optional<Wrapped>:Int

typealias Nested<A> = Outer<A>.Inner<Int>

func f(_ x: Nested<String>) {}

typealias Identity<T> = T

func f(_ x: Identity<String>) {}

typealias H = Outer<String>.Holder

typealias H2 = Outer<String>.Holder2<Int>

func f(_ x: H.InnerAlias<Bool>, _ y: H2.InnerAlias<Bool>) {
    let a = x.getInner()  // $ type=a:Bool target=Outer.Inner.getInner
    let b = x.getOuter()  // $ type=b:String target=Outer.Inner.getOuter
    let c = y.getInner()  // $ type=c:Bool target=Outer.Inner.getInner
    let d = y.getOuter()  // $ type=d:String target=Outer.Inner.getOuter
}

typealias G<A> = Outer<A>.Holder

func f(_ x: G<String>.InnerAlias<Bool>) {
    let outer = x.getOuter()  // $ target=Outer.Inner.getOuter type=outer:String
    let inner = x.getInner()  // $ target=Outer.Inner.getInner type=inner:Bool
}

class Base2<T> {
    struct Nested {
        var x: T

        func getX() -> T {
            return x  // $ field=Base2.Nested.x
        }
    }
}
class Sub: Base2<String> {
    typealias Element = Nested

    typealias Element2 = Sub.Nested
}
class SubSub: Sub {
    func f(
        x1: Sub.Element,  // $ type=x1@Base2.Nested<(parent:Nested)>:Sub
        x2: Element,  // $ type=x2@Base2.Nested<(parent:Nested)>:Sub // in principle `SubSub`, but they are not distinguishable as `Sub` does not have type parameters
        x3: Element2,  // $ type=x3@Base2.Nested<(parent:Nested)>:Sub
        x4: SubSub.Element2  // $ type=x4@Base2.Nested<(parent:Nested)>:Sub
    ) {
        let a = x1.getX()  // $ target=Base2.Nested.getX $ MISSING: type=a:String -- this is an instance of variance sub typing
        let b = x2.getX()  // $ target=Base2.Nested.getX $ MISSING: type=b:String -- this is an instance of variance sub typing
        let c = x3.getX()  // $ target=Base2.Nested.getX $ MISSING: type=c:String -- this is an instance of variance sub typing
        let d = x4.getX()  // $ target=Base2.Nested.getX $ MISSING: type=d:String -- this is an instance of variance sub typing
    }
}

class A<Ta> {

    class B<Tb> {
        class C<Tc> {
            var a: Ta
            var b: Tb
            var c: Tc

            init(a: Ta, b: Tb, c: Tc) {
                self.a = a  // $ field=A.B.C.a
                self.b = b  // $ field=A.B.C.b
                self.c = c  // $ field=A.B.C.c
            }

            typealias Alias = B<Character>

            func getA() -> Ta {
                return a  // $ field=A.B.C.a
            }

            func getB() -> Tb {
                return b  // $ field=A.B.C.b
            }

            func getC() -> Tc {
                return c  // $ field=A.B.C.c
            }
        }
    }

    func f(x: A<UInt>.B<Int>.C<String>.Alias.C<Bool>, y: B<String>.C<Bool>.Alias.C<String>) {
        var a1 = x.getA()  // $ type=a1:UInt target=A.B.C.getA
        let b1 = x.getB()  // $ type=b1:Character target=A.B.C.getB
        var c1 = x.getC()  // $ type=c1:Bool target=A.B.C.getC
        var a2 = y.getA()  // $ type=a2:Ta target=A.B.C.getA
        let b2 = y.getB()  // $ type=b2:Character target=A.B.C.getB
        var c2 = y.getC()  // $ type=c2:String target=A.B.C.getC
    }
}
