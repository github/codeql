package p;

import java.io.IOException;
import java.io.InputStream;
import java.net.ServerSocket;
import java.net.URL;
import java.util.List;

public class Sources {

  // Defined as a source in the model file next to the test.
  // neutral=p;Sources;source;();summary;df-generated
  public String source() {
    return "";
  }

  // source=p;Sources;true;readUrl;(URL);;ReturnValue;remote;df-generated
  // sink=p;Sources;true;readUrl;(URL);;Argument[0];request-forgery;df-generated
  // neutral=p;Sources;readUrl;(URL);summary;df-generated
  public InputStream readUrl(final URL url) throws IOException {
    return url.openConnection().getInputStream();
  }

  // source=p;Sources;true;socketStream;();;ReturnValue;remote;df-generated
  // neutral=p;Sources;socketStream;();summary;df-generated
  public InputStream socketStream() throws IOException {
    ServerSocket socket = new ServerSocket(123);
    return socket.accept().getInputStream();
  }

  // source=p;Sources;true;wrappedSocketStream;();;ReturnValue;remote;df-generated
  // neutral=p;Sources;wrappedSocketStream;();summary;df-generated
  public InputStream wrappedSocketStream() throws IOException {
    return socketStream();
  }

  // source=p;Sources;true;sourceToParameter;(InputStream[],List);;Argument[0].ArrayElement;remote;df-generated
  // source=p;Sources;true;sourceToParameter;(InputStream[],List);;Argument[1].Element;remote;df-generated
  // neutral=p;Sources;sourceToParameter;(InputStream[],List);summary;df-generated
  public void sourceToParameter(InputStream[] streams, List<InputStream> otherStreams)
      throws IOException {
    ServerSocket socket = new ServerSocket(123);
    streams[0] = socket.accept().getInputStream();
    otherStreams.add(socket.accept().getInputStream());
  }

  // Not a new source because a simple type is used in an intermediate step
  // neutral=p;Sources;wrapSourceGetBool;();summary;df-generated
  public Boolean wrapSourceGetBool() {
    String s = source();
    return s == "hello";
  }

  public class SourceReader {
    @Override
    public String toString() {
      return source();
    }
  }

  public class MyContainer<T> {
    private T value;

    // neutral=p;Sources$MyContainer;read;();summary;df-generated
    public String read() {
      return value.toString();
    }
  }

  // Not a new source as this callable has been manually modelled
  // as source neutral.
  // neutral=p;Sources;manualNeutralSource;();summary;df-generated
  public String manualNeutralSource() {
    return source();
  }

  // Not a new source as this callable already has a manual source.
  // neutral=p;Sources;manualSourceAlreadyDefined;();summary;df-generated
  public String manualSourceAlreadyDefined() {
    return source();
  }
}
