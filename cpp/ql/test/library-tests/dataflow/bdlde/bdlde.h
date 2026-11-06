// Minimal public declarations, with implementation bodies omitted to test the models.
// https://github.com/bloomberg/bde/tree/ec310b87e008199ecbdbc00a0b0264a53d806a0a/groups/bdl/bdlde
namespace BloombergLP {
namespace bdlde {
class Base64Encoder {
public:
  template <class OUTPUT_ITERATOR, class INPUT_ITERATOR>
  int convert(OUTPUT_ITERATOR out, INPUT_ITERATOR begin, INPUT_ITERATOR end);
  template <class OUTPUT_ITERATOR, class INPUT_ITERATOR>
  int convert(OUTPUT_ITERATOR out, int *numOut, int *numIn,
              INPUT_ITERATOR begin, INPUT_ITERATOR end, int maxNumOut = -1);
};
class Base64Decoder {
public:
  template <class OUTPUT_ITERATOR, class INPUT_ITERATOR>
  int convert(OUTPUT_ITERATOR out, INPUT_ITERATOR begin, INPUT_ITERATOR end);
  template <class OUTPUT_ITERATOR, class INPUT_ITERATOR>
  int convert(OUTPUT_ITERATOR out, int *numOut, int *numIn,
              INPUT_ITERATOR begin, INPUT_ITERATOR end, int maxNumOut = -1);
};
class HexEncoder {
public:
  template <class OUTPUT_ITERATOR, class INPUT_ITERATOR>
  int convert(OUTPUT_ITERATOR out, INPUT_ITERATOR begin, INPUT_ITERATOR end);
  template <class OUTPUT_ITERATOR, class INPUT_ITERATOR>
  int convert(OUTPUT_ITERATOR out, int *numOut, int *numIn,
              INPUT_ITERATOR begin, INPUT_ITERATOR end, int maxNumOut = -1);
};
class HexDecoder {
public:
  template <class OUTPUT_ITERATOR, class INPUT_ITERATOR>
  int convert(OUTPUT_ITERATOR out, INPUT_ITERATOR begin, INPUT_ITERATOR end);
  template <class OUTPUT_ITERATOR, class INPUT_ITERATOR>
  int convert(OUTPUT_ITERATOR out, int *numOut, int *numIn,
              INPUT_ITERATOR begin, INPUT_ITERATOR end, int maxNumOut = -1);
};
}
}
