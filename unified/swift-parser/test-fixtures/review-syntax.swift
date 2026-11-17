typealias Flat = A & B & C
typealias Tuple = ([String: Int], Int)
enum Choice { case value([String: Int], Int) }
let selected = condition ? items.map { $0 + 1 } : []
let comparisons = [a<b, a<b, a<b, a<b]
foo(x<y)
bar(z>(w))
let body = { count += 1
    for x in values { print(x) }
}
func multilineReturn() -> Int {
    return
        42
}
switch value {
#if DEBUG
case 0: break
#else
case 1: break
#endif
@unknown default: break
}
switch value {
case 0:
#if DEBUG
    print(value)
#else
    break
#endif
default: break
}
