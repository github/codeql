import javascript

query Base64::Encode test_Encode() { any() }

query predicate test_Encode_input_output(
  Base64::Encode encode, DataFlow::Node input, DataFlow::Node output
) {
  input = encode.getInput() and
  output = encode.getOutput()
}
