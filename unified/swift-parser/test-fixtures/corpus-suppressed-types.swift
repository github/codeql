struct Noncopyable<T: ~Copyable>: ~Copyable & ~Escapable {}
func suppressed<T: ~Copyable>(_ value: borrowing T) {}
class Model {
    public class override var databaseTableName: String { "table" }
    class final func construct() {}
}
