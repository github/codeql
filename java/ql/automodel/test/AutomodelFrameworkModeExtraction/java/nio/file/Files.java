package java.nio.file;

import java.io.InputStream;
import java.io.FileInputStream;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.OpenOption;

public class Files {
    public static void copy( // method result is not a candidate source (void)
        Path source, // $ positiveExample=copy(Path,OutputStream):Argument[0](path-injection) // manual model exists
        OutputStream out // $ sinkModel=copy(Path,OutputStream):Argument[1] 
        /* NB: may be worthwhile to implement the
           same behavior as in application mode where out would not be a
           candidate because there already is a model for another parameter of
           the same method and we assume that methods are always modeled
           completely.
         */
    ) throws IOException {
        // ...
    }

    public static InputStream newInputStream( // $ sourceModel=newInputStream(Path,OpenOption[]):ReturnValue
        Path openPath, // $ positiveExample=newInputStream(Path,OpenOption[]):Argument[0](path-injection) sinkModel=newInputStream(Path,OpenOption[]):Argument[0] // known sink, but still a candidate (ai-modeled, and useful as a candidate in regression testing)
        OpenOption... options // $ sinkModel=newInputStream(Path,OpenOption[]):Argument[1]
    ) throws IOException {
        return  new FileInputStream(openPath.toFile());
    }
}
