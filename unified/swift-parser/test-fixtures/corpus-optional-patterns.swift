switch pair {
case (let moduleName??, let name?):
    use(moduleName, name)
case (_, nil), (nil?, _):
    break
default:
    break
}
switch optional {
case let value???:
    use(value)
default:
    break
}
let chained = value??.member
let coalesced = value ?? fallback
