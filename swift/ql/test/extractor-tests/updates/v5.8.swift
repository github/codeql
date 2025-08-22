// https://github.com/apple/swift/blob/main/CHANGELOG.md#swift-58

@available(macOS 12, *)
public struct Temperature {
    public var degreesCelsius: Double

    // ...
}

extension Temperature {
    @available(macOS 12, *)
    @backDeployed(before: macOS 13)
    public var degreesFahrenheit: Double {
        return (degreesCelsius * 9 / 5) + 32
    }
}

func collectionDowncast(_ arr: [Any]) {
    switch arr {
    case let ints as [Int]:
            0
    case is [Bool]:
            1
    case _:
            2
    }
}

struct Button {
    var tapHandler: (() -> ())?
}

class ViewController {
    var button: Button = Button()

    func setup() {
        button.tapHandler = { [weak self] in
            guard let self else { return }
            dismiss() // refers to `self.dismiss()`
        }
    }

    func dismiss() {}
}
