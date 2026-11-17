switch value {
case let .onlyConfiguration(rules) where rules.contains {
    $0 == CustomRule.identifier
}:
    use(rules)
default:
    break
}
