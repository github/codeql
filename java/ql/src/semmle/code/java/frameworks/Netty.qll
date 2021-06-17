import java
private import semmle.code.java.dataflow.FlowSteps
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.dataflow.ExternalFlow

/**
 * Netty methods that access user-supplied request data.
 */
private class NettySource extends SourceModelCsv {
  override predicate row(string row) {
    row = [
      "io.netty.channel;ChannelInboundHandler;true;channelRead;;;Parameter[1];remote",
      "io.netty.handler.codec;ByteToMessageDecoder;true;callDecode;;;Parameter[1];remote",
      "io.netty.handler.codec;ByteToMessageDecoder;true;decode;;;Parameter[1];remote",
      "io.netty.handler.codec;ByteToMessageDecoder;true;decodeLast;;;Parameter[1];remote"
    ]
  }
}

/**
 * Netty methods that propagate user-supplied request data as tainted.
 */
private class NettyModel extends SummaryModelCsv {
  override predicate row(string row) {
    row = [
      "io.netty.buffer;ByteBuf;true;getBuffer;;;Argument[-1];ReturnValue;taint",
      "io.netty.buffer;ByteBuf;true;getByte;;;Argument[-1];ReturnValue;taint",
      "io.netty.buffer;ByteBuf;true;getBytes;;;Argument[-1];ReturnValue;taint",
      "io.netty.buffer;ByteBuf;true;getChar;;;Argument[-1];ReturnValue;taint",
      "io.netty.buffer;ByteBuf;true;getCharSequence;;;Argument[-1];ReturnValue;taint",
      "io.netty.buffer;ByteBuf;true;getCharSequence;;;Argument[-1];ReturnValue;taint",
      "io.netty.buffer;ByteBuf;true;readBytes;;;Argument[-1];ReturnValue;taint",
      "io.netty.buffer;ByteBuf;true;readChar;;;Argument[-1];ReturnValue;taint",
      "io.netty.buffer;ByteBuf;true;readCharSequence;;;Argument[-1];ReturnValue;taint",
      "io.netty.buffer;ByteBuf;true;readSlice;;;Argument[-1];ReturnValue;taint",
      "io.netty.buffer;ByteBufHolder;true;content;;;Argument[-1];ReturnValue;taint",

      "io.netty.buffer;ByteBuf;true;readBytes;;;Argument[-1];Argument[0];taint",

      "io.netty.buffer;ByteBuf;true;setByte;;;Argument[1];Argument[-1];taint",
      "io.netty.buffer;ByteBuf;true;setBytes;;;Argument[1];Argument[-1];taint",
      "io.netty.buffer;ByteBuf;true;setChar;;;Argument[1];Argument[-1];taint",
      "io.netty.buffer;ByteBuf;true;setCharSequence;;;Argument[1];Argument[-1];taint",

      "io.netty.buffer;ByteBuf;true;writeByte;;;Argument[0];Argument[-1];taint",
      "io.netty.buffer;ByteBuf;true;writeBytes;;;Argument[0];Argument[-1];taint",
      "io.netty.buffer;ByteBuf;true;writeChar;;;Argument[0];Argument[-1];taint",
      "io.netty.buffer;ByteBuf;true;writeCharSequence;;;Argument[1];Argument[-1];taint",

      "io.netty.handler.codec.http;HttpHeaders;true;entries;;;Argument[-1];ReturnValue;taint",
      "io.netty.handler.codec.http;HttpHeaders;true;get;;;Argument[-1];ReturnValue;taint",
      "io.netty.handler.codec.http;HttpHeaders;true;getAll;;;Argument[-1];ReturnValue;taint",
      "io.netty.handler.codec.http;HttpHeaders;true;getAllAsString;;;Argument[-1];ReturnValue;taint",
      "io.netty.handler.codec.http;HttpHeaders;true;getAsString;;;Argument[-1];ReturnValue;taint",
      "io.netty.handler.codec.http;HttpHeaders;true;getHeader;;;Argument[-1];ReturnValue;taint",
      "io.netty.handler.codec.http;HttpHeaders;true;valueCharSequenceIterator;;;Argument[-1];ReturnValue;taint",
      "io.netty.handler.codec.http;HttpHeaders;true;valueStringIterator;;;Argument[-1];ReturnValue;taint",
      "io.netty.handler.codec.http;HttpMessage;true;headers;;;Argument[-1];ReturnValue;taint",
      "io.netty.handler.codec.http;HttpMessage;true;trailingHeaders;;;Argument[-1];ReturnValue;taint"
    ]
  }
}

