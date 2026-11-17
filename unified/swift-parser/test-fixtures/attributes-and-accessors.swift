@available(*, deprecated: 4.2.0, message: "Use newValue")
public class Observer {
    private(set) public var value: Int = 0 {
        didSet { notify(&value) }
    }
    var floating: some Any = 0.0 { 0 }
    var integer = 0 { 1 }
    var boolean = true { false }
    var string = "value" { "other" }
    var regex = /value/ { /other/ }
    var nothing: Int? = nil { 0 }
    let literalMember = "text".map { $0 }
    let arrayBuilder = [Int] { 0 }
    var title: String {
        get { return "title" }
        set(next) { print(next) }
    }
    lazy var callback = { [weak self] in self?.notify() }
    func notify() {
        install(action: #selector(Observer.update(_:)))
    }
}
