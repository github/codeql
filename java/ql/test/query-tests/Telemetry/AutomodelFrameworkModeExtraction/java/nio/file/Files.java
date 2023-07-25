package java.nio.file;

import java.nio.file.Path;
import java.io.IOException;
import java.io.OutputStream;

public class Files {
    public static void copy(
        Path source, // a positive example because a manual model exists
        OutputStream out // a candidate. NB: may be worthwhile to implement the same behavior as in application mode where out
    ) throws IOException {
        // ...
    }
}
