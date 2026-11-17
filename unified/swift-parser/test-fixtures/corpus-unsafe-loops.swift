for unsafe continuation in unsafe continuations {
    unsafe continuation.resume(returning: nil)
}
for unsafe in values {
    use(unsafe)
}
