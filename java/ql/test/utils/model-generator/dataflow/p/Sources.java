package p;

import java.io.IOException;
import java.io.InputStream;
import java.net.ServerSocket;
import java.net.URL;
import java.util.function.Consumer;
import java.util.List;


public class Sources {
    
    public InputStream readUrl(final URL url) throws IOException {
        return url.openConnection().getInputStream();
    }

    public InputStream socketStream() throws IOException {
        ServerSocket socket = new ServerSocket(123);
        return socket.accept().getInputStream();
    }

    public InputStream wrappedSocketStream() throws IOException {
        return socketStream();
    }

    public void sourceToParameter(InputStream[] streams, List<InputStream> otherStreams) throws IOException {
        ServerSocket socket = new ServerSocket(123);
        streams[0] = socket.accept().getInputStream();
        otherStreams.add(socket.accept().getInputStream());
    }

}
