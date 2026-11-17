let types = [Name: [() -> Void]]()
for value in repeat each values { print(value) }
var count = Int(2) { didSet { print(count) } }
let view = Content()
#if DEBUG
    .background(Color.red)
#elseif os(macOS)
    .foregroundColor(Color.blue)
#else
    .padding()
#endif
    .onAppear { print("appeared") }
