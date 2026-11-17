let values = data.filter { set in set.contains(item) }
let filtered = data.filter { set.contains($0) }
if let record = items.flatMap { Record(rawValue: $0) } {
    use(record)
}
for item in items.filter { $0 > 4 } {
    use(item)
}
switch value {
case .compound(let a) where a.map { $0 < 0 } ?? false:
    break
default:
    break
}
var observed = source { didSet { notify() } }
let closure = apply { get in get }
let braces = apply { "{".contains($0) }
struct Content {
    var body: some View {
        @Binding(store.$data) var data
        Form { TextField("Name", text: $data.name) }
    }
}
