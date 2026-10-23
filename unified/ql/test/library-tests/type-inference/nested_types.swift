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

    func f(z: Outer<String>.Holder.InnerAlias<Bool>) {
        let a = z.getInner()  // $ target=Outer.Inner.getInner $ MISSING: type=a:Bool
        let b = z.getOuter()  // $ target=Outer.Inner.getOuter $ MISSING: type=b:String
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
    class Leaf: Node {
        let x: Leaf = Leaf()  // $ type=x@Node.Leaf<(parent:Leaf)>:Node target=Node.init
    }
}

class Holder { typealias Fixed = Outer<Int>.Inner }

let holder = Holder.Fixed(innerValue: "")  // $ target=Outer.Inner.init $ SPURIOUS: target=Outer.Inner.init_conv
let x13 = holder.getInner()  // $ target=Outer.Inner.getInner type=x13:String
let y13 = holder.getOuter()  // $ target=Outer.Inner.getOuter type=y13:Int

class Box<T> {
    typealias IntBox = Box<Int>

    typealias Same = Box

    func f(_ x: IntBox, _ y: Box<Int>.Same) {}  // $ MISSING: type=y@Box<T>:Int $ SPURIOUS: type=y@Box<T>:T
}
