// Simple interpolation
"hello \(name)"

// Multiple interpolations
"hello \(first) \(last)"

// Interpolation with expression
"result: \(x + y)"

// Plain string before and after interpolation
"prefix \(value) suffix"

// Calls to custom DefaultStringInterpolation.appendInterpolation impls
"foo \(x, y)"
"foo \(x, y, z)"
"foo \(arg: x)"
"foo \(arg: x, arg2: y)"
