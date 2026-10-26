package hudson;

import java.io.File;
import java.io.InputStream;
import java.nio.file.OpenOption;

public class FilePath {

    public static InputStream newInputStreamDenyingSymlinkAsNeeded(File file,
            String verificationRoot, OpenOption... openOption) {
        return null;
    }

    public static InputStream openInputStream(File file, OpenOption[] openOptions) {
        return null;
    }

    public InputStream read() {
        return null;
    }

    public InputStream read(FilePath rootPath, OpenOption... openOptions) {
        return null;
    }

    public InputStream readFromOffset(long offset) {
        return null;
    }

    public String readToString() {
        return null;
    }
}

