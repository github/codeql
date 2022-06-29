public class PartialPathTraversalBad {
    public void esapiExample(File dir, File parent) throws IOException {
        if (!dir.getCanonicalPath().startsWith(parent.getCanonicalPath())) {
            throw new IOException("Invalid directory: " + dir.getCanonicalPath());
        }
    }
}
