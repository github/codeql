#include "bdlde.h"

char source();
void sink(char);

// Reduced iterator access bodies: the object instantiations must remain
// analyzable rather than being replaced by pointer-buffer summaries.
struct InputIterator {
  char value;
  char operator*() const { return value; }
};

struct OutputIterator {
  OutputIterator &operator*() { return *this; }
  void operator=(char value) { sink(value); } // $ ir
};

namespace BloombergLP {
namespace bdlde {
template <class OUT, class IN>
int Base64Encoder::convert(OUT out, IN begin, IN end) {
  *out = *begin;
  return 0;
}

template <class OUT, class IN>
int Base64Encoder::convert(OUT out, int *numOut, int *numIn, IN begin, IN end, int limit) {
  *out = *begin;
  return 0;
}
template <class OUT, class IN>
int Base64Decoder::convert(OUT out, IN begin, IN end) {
  *out = *begin;
  return 0;
}

template <class OUT, class IN>
int Base64Decoder::convert(OUT out, int *numOut, int *numIn, IN begin, IN end, int limit) {
  *out = *begin;
  return 0;
}
template <class OUT, class IN>
int HexEncoder::convert(OUT out, IN begin, IN end) {
  *out = *begin;
  return 0;
}

template <class OUT, class IN>
int HexEncoder::convert(OUT out, int *numOut, int *numIn, IN begin, IN end, int limit) {
  *out = *begin;
  return 0;
}
template <class OUT, class IN>
int HexDecoder::convert(OUT out, IN begin, IN end) {
  *out = *begin;
  return 0;
}

template <class OUT, class IN>
int HexDecoder::convert(OUT out, int *numOut, int *numIn, IN begin, IN end, int limit) {
  *out = *begin;
  return 0;
}
}
}

void iteratorBase64Encoder() {
  BloombergLP::bdlde::Base64Encoder converter;
  InputIterator begin = {source()}, end = {0};
  char shortOutput[4] = {};
  converter.convert(shortOutput, begin, end);
  sink(shortOutput[0]); // $ ir
  int numOut = 0, numIn = 0;
  char longOutput[4] = {};
  converter.convert(longOutput, &numOut, &numIn, begin, end);
  sink(longOutput[0]); // $ ir
}

void iteratorBase64Decoder() {
  BloombergLP::bdlde::Base64Decoder converter;
  InputIterator begin = {source()}, end = {0};
  char shortOutput[4] = {};
  converter.convert(shortOutput, begin, end);
  sink(shortOutput[0]); // $ ir
  int numOut = 0, numIn = 0;
  char longOutput[4] = {};
  converter.convert(longOutput, &numOut, &numIn, begin, end);
  sink(longOutput[0]); // $ ir
}

void iteratorHexEncoder() {
  BloombergLP::bdlde::HexEncoder converter;
  InputIterator begin = {source()}, end = {0};
  char shortOutput[4] = {};
  converter.convert(shortOutput, begin, end);
  sink(shortOutput[0]); // $ ir
  int numOut = 0, numIn = 0;
  char longOutput[4] = {};
  converter.convert(longOutput, &numOut, &numIn, begin, end);
  sink(longOutput[0]); // $ ir
}

void iteratorHexDecoder() {
  BloombergLP::bdlde::HexDecoder converter;
  InputIterator begin = {source()}, end = {0};
  char shortOutput[4] = {};
  converter.convert(shortOutput, begin, end);
  sink(shortOutput[0]); // $ ir
  int numOut = 0, numIn = 0;
  char longOutput[4] = {};
  converter.convert(longOutput, &numOut, &numIn, begin, end);
  sink(longOutput[0]); // $ ir
}

template <class CONVERTER>
void outputIterator() {
  CONVERTER converter;
  char input[] = {source()};
  OutputIterator out;
  converter.convert(out, input, input + 1);
  int numOut = 0, numIn = 0;
  converter.convert(out, &numOut, &numIn, input, input + 1);
}

void testOutputIterators() {
  outputIterator<BloombergLP::bdlde::Base64Encoder>();
  outputIterator<BloombergLP::bdlde::Base64Decoder>();
  outputIterator<BloombergLP::bdlde::HexEncoder>();
  outputIterator<BloombergLP::bdlde::HexDecoder>();
}
