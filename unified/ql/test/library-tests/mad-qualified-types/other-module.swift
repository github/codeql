import Other
import Other.URL

// Types named `URL` in unrelated modules must not match the Foundation models.
func withOtherModule(url: Other.URL, path: String) {
    _ = url.lines
    let qualified = Other.URL(fileURLWithPath: path)
    _ = qualified.lines
    _ = Other.URL.init(fileURLWithPath: path)
}
