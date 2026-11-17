@_documentation(visibility: public, metadata: "Metadata")
func documented() {}
@available(*, deprecated, message: """
    Use the replacement instead.
    """)
func old() {}
do throws(MyError) {
    try work()
} catch { print(error) }
