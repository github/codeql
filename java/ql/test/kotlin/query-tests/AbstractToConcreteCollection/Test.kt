fun fn(m: MutableList<Int>) {
    if (m is ArrayList) {
        m.ensureCapacity(5)
    }
}
