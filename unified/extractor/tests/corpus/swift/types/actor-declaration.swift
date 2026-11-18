public actor Store<T: Sendable>: Sendable where T: Equatable {
  let value: T

  init(value: T) {
    self.value = value
  }
}
