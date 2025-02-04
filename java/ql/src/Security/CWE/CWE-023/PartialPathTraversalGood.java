import java.io.File;

public class PartialPathTraversalGood {
    public void example(File dir, File parent) throws IOException {
        // GOOD: Check if dir.Path() is normalised
        if (!dir.toPath().normalize().startsWith(parent.toPath())) {
            throw new IOException("Path traversal attempt: " + dir.getCanonicalPath());
        }
    }
}
