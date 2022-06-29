import java.io.File;

public class PartialPathTraversalBad {
    public void esapiExample(File dir, File parent) throws IOException {
        if (!dir.getCanonicalPath().startsWith(parent.getCanonicalPath() + File.separator)) {
            throw new IOException("Invalid directory: " + dir.getCanonicalPath());
        }
    }
}
