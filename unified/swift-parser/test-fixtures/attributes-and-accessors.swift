@available(*, deprecated: 4.2.0, message: "Use newValue")
public class Observer {
    private(set) public var value: Int = 0 {
        didSet { notify(&value) }
    }
    var title: String {
        get { return "title" }
        set(next) { print(next) }
    }
    lazy var callback = { [weak self] in self?.notify() }
    func notify() {
        install(action: #selector(Observer.update(_:)))
    }
}
