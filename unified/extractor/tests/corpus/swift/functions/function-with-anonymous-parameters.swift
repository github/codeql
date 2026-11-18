func ignore(_: Int, _: String) {
}

func ignore(first _: Int, second _: String) {
}

let ignoreClosure: (Int, String) -> Void = { _, _ in
}

let ignoreTypedClosure = { (_: Int, _: String) in
}
