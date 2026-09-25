#include "bdlde.h"

char source();
void sink(char);

void testBase64Encoder() {
  BloombergLP::bdlde::Base64Encoder converter;
  char input[] = {source(), 'A', 'A', 'A'};
  const char *begin = input;
  char shortOutput[32] = {};
  converter.convert(shortOutput, input, input + 4);
  sink(shortOutput[0]); // $ ir

  int numOut = 0, numIn = 0;
  char defaultLimitOutput[32] = {};
  converter.convert(defaultLimitOutput, &numOut, &numIn, begin, begin + 4);
  sink(defaultLimitOutput[0]); // $ ir

  char explicitLimitOutput[32] = {};
  converter.convert(explicitLimitOutput, &numOut, &numIn, begin, begin + 4, 32);
  sink(explicitLimitOutput[0]); // $ ir
}

void testBase64EncoderNonInputs() {
  BloombergLP::bdlde::Base64Encoder converter;
  const char input[] = "AAAA";
  int numOut = source(), numIn = source();
  char output[32] = {};
  converter.convert(output, &numOut, &numIn, input, input + 4);
  sink(output[0]); // No flow from the pre-call values of the output counters.

  char limitedOutput[32] = {};
  converter.convert(limitedOutput, &numOut, &numIn, input, input + 4, source());
  sink(limitedOutput[0]); // The output limit does not supply output bytes.
}

void testBase64Decoder() {
  BloombergLP::bdlde::Base64Decoder converter;
  char input[] = {source(), 'A', 'A', 'A'};
  const char *begin = input;
  char shortOutput[32] = {};
  converter.convert(shortOutput, input, input + 4);
  sink(shortOutput[0]); // $ ir

  int numOut = 0, numIn = 0;
  char defaultLimitOutput[32] = {};
  converter.convert(defaultLimitOutput, &numOut, &numIn, begin, begin + 4);
  sink(defaultLimitOutput[0]); // $ ir

  char explicitLimitOutput[32] = {};
  converter.convert(explicitLimitOutput, &numOut, &numIn, begin, begin + 4, 32);
  sink(explicitLimitOutput[0]); // $ ir
}

void testBase64DecoderNonInputs() {
  BloombergLP::bdlde::Base64Decoder converter;
  const char input[] = "AAAA";
  int numOut = source(), numIn = source();
  char output[32] = {};
  converter.convert(output, &numOut, &numIn, input, input + 4);
  sink(output[0]); // No flow from the pre-call values of the output counters.

  char limitedOutput[32] = {};
  converter.convert(limitedOutput, &numOut, &numIn, input, input + 4, source());
  sink(limitedOutput[0]); // The output limit does not supply output bytes.
}

void testHexEncoder() {
  BloombergLP::bdlde::HexEncoder converter;
  char input[] = {source(), 'A', 'A', 'A'};
  const char *begin = input;
  char shortOutput[32] = {};
  converter.convert(shortOutput, input, input + 4);
  sink(shortOutput[0]); // $ ir

  int numOut = 0, numIn = 0;
  char defaultLimitOutput[32] = {};
  converter.convert(defaultLimitOutput, &numOut, &numIn, begin, begin + 4);
  sink(defaultLimitOutput[0]); // $ ir

  char explicitLimitOutput[32] = {};
  converter.convert(explicitLimitOutput, &numOut, &numIn, begin, begin + 4, 32);
  sink(explicitLimitOutput[0]); // $ ir
}

void testHexEncoderNonInputs() {
  BloombergLP::bdlde::HexEncoder converter;
  const char input[] = "AAAA";
  int numOut = source(), numIn = source();
  char output[32] = {};
  converter.convert(output, &numOut, &numIn, input, input + 4);
  sink(output[0]); // No flow from the pre-call values of the output counters.

  char limitedOutput[32] = {};
  converter.convert(limitedOutput, &numOut, &numIn, input, input + 4, source());
  sink(limitedOutput[0]); // The output limit does not supply output bytes.
}

void testHexDecoder() {
  BloombergLP::bdlde::HexDecoder converter;
  char input[] = {source(), 'A', 'A', 'A'};
  const char *begin = input;
  char shortOutput[32] = {};
  converter.convert(shortOutput, input, input + 4);
  sink(shortOutput[0]); // $ ir

  int numOut = 0, numIn = 0;
  char defaultLimitOutput[32] = {};
  converter.convert(defaultLimitOutput, &numOut, &numIn, begin, begin + 4);
  sink(defaultLimitOutput[0]); // $ ir

  char explicitLimitOutput[32] = {};
  converter.convert(explicitLimitOutput, &numOut, &numIn, begin, begin + 4, 32);
  sink(explicitLimitOutput[0]); // $ ir
}

void testHexDecoderNonInputs() {
  BloombergLP::bdlde::HexDecoder converter;
  const char input[] = "AAAA";
  int numOut = source(), numIn = source();
  char output[32] = {};
  converter.convert(output, &numOut, &numIn, input, input + 4);
  sink(output[0]); // No flow from the pre-call values of the output counters.

  char limitedOutput[32] = {};
  converter.convert(limitedOutput, &numOut, &numIn, input, input + 4, source());
  sink(limitedOutput[0]); // The output limit does not supply output bytes.
}

// Inherited calls still target the method declared in Base64Encoder.
struct DerivedEncoder : BloombergLP::bdlde::Base64Encoder {};

void testInheritedConvert() {
  DerivedEncoder converter;
  char input[] = {source()};
  char output[32] = {};
  converter.convert(output, input, input + 1);
  sink(output[0]); // $ ir
}

// A different method that hides convert must not inherit the summary.
struct HidingEncoder : BloombergLP::bdlde::Base64Encoder {
  template <class OUTPUT_ITERATOR, class INPUT_ITERATOR>
  int convert(OUTPUT_ITERATOR out, INPUT_ITERATOR begin, INPUT_ITERATOR end);
};

void testHiddenConvert() {
  HidingEncoder converter;
  char input[] = {source()};
  char output[32] = {};
  converter.convert(output, input, input + 1);
  sink(output[0]); // No modeled flow for the hiding method.
}
