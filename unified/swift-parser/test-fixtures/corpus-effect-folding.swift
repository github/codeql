let delimiter = "("
let conditionalDelimiter = "#if"
infix operator ==>

func effects() async throws {
    output = try value ==> transform
    output = await value ==> transform
    output = unsafe value ==> transform
    let standard = try await first() + second() * third()
    let optional = try? first() + second()
    let cast = try value as? Element
    let conditional = unsafe flag ? first() : second()
    let unknown = first <~> try second + third
    let nonAssociative = try first < second < third
    let ownership = consume try first() + second()
}
