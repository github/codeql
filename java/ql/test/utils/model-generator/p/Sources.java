package p;

import java.io.IOException;
import java.io.InputStream;
import java.net.ServerSocket;
import java.net.URL;
import java.util.function.Consumer;


public class Sources {
    
    public InputStream readUrl(final URL url) throws IOException {
        return url.openConnection().getInputStream();
    }

    public InputStream socketStream() throws IOException {
        ServerSocket socket = new ServerSocket(123);
        return socket.accept().getInputStream();
    }

}
