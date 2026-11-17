let bytes: InlineArray<8, UInt8>
let negative: Constant<-1>
let nested = Buffer<8, Vector<4, UInt8>>()
struct Vector<let count: Int, Element> {}
extension Vector where count == 2 {}
extension Vector where count == -2 {}
extension Vector where 2 == count {}
extension Vector where -2 == -2 {}
