package java.nio.file;

import java.io.InputStream;
import java.io.FileInputStream;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.OpenOption;

public class Files {
    public static void copy(
        Path source, // a positive example because a manual model exists
        OutputStream out /* a candidate. NB: may be worthwhile to implement the
           same behavior as in application mode where out would not be a
           candidate because there already is a model for another parameter of
           the same method and we assume that methods are always modeled
           completely.
         */
    ) throws IOException {
        // ...
    } // method copy is a candidate source

    public static InputStream newInputStream(
        Path openPath ,// positive example (known sink), candidate (ai-modeled, and useful as a candidate in regression testing)
        OpenOption... options 
    ) throws IOException {
        return  new FileInputStream(openPath.toFile());
    } // method newInputStream is a candidate source
}
