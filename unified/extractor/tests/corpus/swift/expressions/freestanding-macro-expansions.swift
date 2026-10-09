#expect(value == 42)

#custom<Int>(value) {
  value
} completion: {
  value
}

#Preview {
  let previewValue = 42
  previewValue
}
