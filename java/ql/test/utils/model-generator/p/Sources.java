package p;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;


public class Sources {
    
    public InputStream readUrl(final URL url) throws IOException {
        return url.openConnection().getInputStream();
    }

}
