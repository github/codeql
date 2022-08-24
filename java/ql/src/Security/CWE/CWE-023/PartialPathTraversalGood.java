public class PartialPathTraversalGood {
    public void example(File dir, File parent) throws IOException {
        if (!dir.getCanonicalPath().toPath().startsWith(parent.getCanonicalPath().toPath())) {
            throw new IOException("Invalid directory: " + dir.getCanonicalPath());
        }
    }
}
