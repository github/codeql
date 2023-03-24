//codeql-extractor-expected-status: 1

extension Undefined { }

enum Enum {
    case A, B

    func test(e: Enum) {
        fallthrough

        switch e {
            case .A():
            break
            case .B(let x):
            let _ = x
            break
            case Int:
            break
            case .C:
            break
            default:
            fallthrough
        }

        switch undefined {
            case .Whatever:
            break
        }
    }
}
