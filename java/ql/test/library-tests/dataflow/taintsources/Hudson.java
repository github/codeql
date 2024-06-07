import hudson.FilePath;

public class Hudson {

    private static void sink(Object o) {}

    public static void test() throws Exception {
        FilePath fp = null;
        sink(FilePath.newInputStreamDenyingSymlinkAsNeeded(null, null, null)); // $hasLocalValueFlow
        sink(FilePath.openInputStream(null, null)); // $hasLocalValueFlow
        sink(fp.read()); // $hasLocalValueFlow
        sink(fp.read(null)); // $hasLocalValueFlow
        sink(fp.readFromOffset(-1)); // $hasLocalValueFlow
        sink(fp.readToString()); // $hasLocalValueFlow
    }
}
