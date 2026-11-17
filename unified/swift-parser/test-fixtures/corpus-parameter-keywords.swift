func contains<Source>(_ self: Source, where predicate: (Source) -> Bool) -> Bool {
    predicate(self)
}
func labelled(self: Source) {}
func modified(_const _ value: Int, isolated _ actor: Actor, _const name: Int) {}
let closure = { (_const _ value: Int, isolated actor: Actor, isolated) in use(value) }
let variadicClosure = { (_ values: Int...) in use(values) }
let untypedVariadic = { (values ...) in use(values) }
enum Parameters {
    case modified(isolated Actor)
}
