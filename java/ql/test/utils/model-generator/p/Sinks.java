package p;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.nio.file.CopyOption;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.logging.Logger;

public class Sinks {
    
    public Path copyFileToDirectory(final Path sourceFile, final Path targetFile, final CopyOption... copyOptions) throws IOException {
        return Files.copy(sourceFile, targetFile, copyOptions);
    }

    public String readUrl(final URL url, Charset encoding) throws IOException {
        try (InputStream in = url.openStream()) {
            byte[] bytes = in.readAllBytes();
            return new String(bytes, encoding);
        }
    }

    public static void main(String[] args) throws IOException {
        String foo = new Sinks().readUrl(new URL(args[0]), Charset.defaultCharset());
    }

    public void propagate(String s) {
        Logger logger = Logger.getLogger(Sinks.class.getSimpleName());
        logger.warning(s);
    }

}
