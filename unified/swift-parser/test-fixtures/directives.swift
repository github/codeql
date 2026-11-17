#if DEBUG
let mode = "debug"
#elseif os(Linux)
let mode = "linux"
#else
let mode = "release"
#endif

@available(iOS 11.0, macOS 10.13, *)
func update() {
    if #available(iOS 14, *), ready {
        run()
    } else if #unavailable(iOS 12) {
        fallback()
    }
}
