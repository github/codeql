import javascript

query Base64::Decode test_Decode() { any() }

query predicate test_Decode_input_output(
  Base64::Decode decode, DataFlow::Node input, DataFlow::Node output
) {
  input = decode.getInput() and
  output = decode.getOutput()
}
