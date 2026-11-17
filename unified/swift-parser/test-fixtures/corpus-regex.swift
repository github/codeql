/\(/
#/\(/#
let path = /\/([:ascii:]+)/
let classes = /[a-z\/]+/
let escaped = /a\/b/
let raw = #/ literal / and \# space /#
let divided = a/b/c + a / b
let matched = input.wholeMatch(of: /foo+/)
bar(!!/a/)
let negated = !!/abc/
Regex {
    /abc/
    /def/
    "text"
    /g(h)(i)/
}
func clone(_ copy: Value) -> Value {
    let value = copy as? Subclass
    return copy
}
