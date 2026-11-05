struct Resource: ~Copyable {
  consuming func close() {
    discard self
  }
}
