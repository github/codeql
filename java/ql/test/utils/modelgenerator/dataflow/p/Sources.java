package p;

import java.io.IOException;
import java.io.InputStream;
import java.net.ServerSocket;
import java.net.URL;
import java.util.List;

public class Sources {

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
}
