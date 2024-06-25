import cpp

/**
 * The Decompression Sink instances, extend this class to defind new decompression sinks.
 */
abstract class DecompressionFunction extends Function {
  abstract int getArchiveParameterIndex();
}
