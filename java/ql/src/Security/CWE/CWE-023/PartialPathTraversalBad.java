public class PartialPathTraversalBad {
    public void example(File dir, File parent) throws IOException {
        if (!dir.getCanonicalPath().startsWith(parent.getCanonicalPath())) {
            throw new IOException("Path traversal attempt: " + dir.getCanonicalPath());
        }
    }
}
