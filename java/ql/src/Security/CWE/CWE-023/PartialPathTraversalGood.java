import java.io.File;

public class PartialPathTraversalGood {
    public void example(File dir, File parent) throws IOException {
        if (!dir.toPath().normalize().startsWith(parent.toPath())) {
            throw new IOException("Path traversal attempt: " + dir.getCanonicalPath());
        }
    }
}
