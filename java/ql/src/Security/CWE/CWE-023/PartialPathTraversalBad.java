public class PartialPathTraversalBad {
    public void example(File dir, File parent) throws IOException {
        if (!dir.getCanonicalPath().startsWith(parent.getCanonicalPath())) { // BAD: dir.getCanonicalPath() not slash-terminated
            throw new IOException("Path traversal attempt: " + dir.getCanonicalPath());
        }
    }
}
