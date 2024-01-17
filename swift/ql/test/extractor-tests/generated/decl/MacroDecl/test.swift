@freestanding(declaration)
macro A() = #externalMacro(module: "A", type: "A")
@freestanding(expression)
macro B() = B.B
@attached(member)
@attached(extension)
macro C() = C.C