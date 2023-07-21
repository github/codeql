package java.nio.file;

import java.nio.file.Path;
import java.io.IOException;
import java.io.OutputStream;

public class Files {
    // - source is not a candidate because a manual model exists:
    // ["java.nio.file", "Files", False, "copy", "(Path,OutputStream)", "", "Argument[0]", "path-injection", "manual"]
    // - out is a candidate. NB: may be worthwile to implement the same behaviour as in application mode where out
    //   would not be a candidate because another param is already modeled.
    public static void copy(Path source, OutputStream out) throws IOException {
        // ...
    }
}
