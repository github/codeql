import java.io.IOException;
import java.io.File;
import java.io.InputStream;
import static java.io.File.separatorChar;
import java.nio.file.Files;


public class PartialPathTraversalTest {
    public void esapiExample(File dir, File parent) throws IOException {
        if (!dir.getCanonicalPath().startsWith(parent.getCanonicalPath())) { // $hasTaintFlow
            throw new IOException("Invalid directory: " + dir.getCanonicalPath());
        }
    }

    @SuppressWarnings("ResultOfMethodCallIgnored")
    void foo1(File dir, File parent) throws IOException {
        (dir.getCanonicalPath()).startsWith((parent.getCanonicalPath())); // $hasTaintFlow
    }

    void foo2(File dir, File parent) throws IOException {
        dir.getCanonicalPath();
        if ("potato".startsWith(parent.getCanonicalPath())) {
            System.out.println("Hello!");
        }
    }

    void foo3(File dir, File parent) throws IOException {
        String parentPath = parent.getCanonicalPath();
        if (!dir.getCanonicalPath().startsWith(parentPath)) { // $hasTaintFlow
            throw new IOException("Invalid directory: " + dir.getCanonicalPath());
        }
    }

    void foo4(File dir) throws IOException {
        if (!dir.getCanonicalPath().startsWith("/usr" + "/dir")) { // $hasTaintFlow
            throw new IOException("Invalid directory: " + dir.getCanonicalPath());
        }
    }

    void foo5(File dir, File parent) throws IOException {
        String canonicalPath = dir.getCanonicalPath();
        if (!canonicalPath.startsWith(parent.getCanonicalPath())) { // $hasTaintFlow
            throw new IOException("Invalid directory: " + dir.getCanonicalPath());
        }
    }

    void foo6(File dir, File parent) throws IOException {
        String canonicalPath = dir.getCanonicalPath();
        if (!canonicalPath.startsWith(parent.getCanonicalPath())) { // $hasTaintFlow
            throw new IOException("Invalid directory: " + dir.getCanonicalPath());
        }
        String canonicalPath2 = dir.getCanonicalPath();
        if (!canonicalPath2.startsWith(parent.getCanonicalPath())) { // $hasTaintFlow
            throw new IOException("Invalid directory: " + dir.getCanonicalPath());
        }
    }

    void foo7(File dir, File parent) throws IOException {
        String canonicalPath = dir.getCanonicalPath();
        String canonicalPath2 = dir.getCanonicalPath();
        if (!canonicalPath.startsWith(parent.getCanonicalPath())) { // $hasTaintFlow
            throw new IOException("Invalid directory: " + dir.getCanonicalPath());
        }
        if (!canonicalPath2.startsWith(parent.getCanonicalPath())) { // $hasTaintFlow
            throw new IOException("Invalid directory: " + dir.getCanonicalPath());
        }
    }

    File getChild() {
        return null;
    }

    void foo8(File parent) throws IOException {
        String canonicalPath = getChild().getCanonicalPath();
        if (!canonicalPath.startsWith(parent.getCanonicalPath())) { 
            throw new IOException("Invalid directory: " + getChild().getCanonicalPath());
        }
    }

    void foo9(File dir, File parent) throws IOException {
        if (!dir.getCanonicalPath().startsWith(parent.getCanonicalPath() + File.separator)) {
            throw new IOException("Invalid directory: " + dir.getCanonicalPath());
        }
    }

    void foo10(File dir, File parent) throws IOException {
        if (!dir.getCanonicalPath().startsWith(parent.getCanonicalPath() + File.separatorChar)) {
            throw new IOException("Invalid directory: " + dir.getCanonicalPath());
        }
    }

    void foo11(File dir, File parent) throws IOException {
        String parentCanonical = parent.getCanonicalPath();
        if (!dir.getCanonicalPath().startsWith(parentCanonical)) { // $hasTaintFlow
            throw new IOException("Invalid directory: " + dir.getCanonicalPath());
        }
    }

    void foo12(File dir, File parent) throws IOException {
        String parentCanonical = parent.getCanonicalPath();
        String parentCanonical2 = parent.getCanonicalPath();
        if (!dir.getCanonicalPath().startsWith(parentCanonical)) { // $hasTaintFlow
            throw new IOException("Invalid directory: " + dir.getCanonicalPath());
        }
        if (!dir.getCanonicalPath().startsWith(parentCanonical2)) { // $hasTaintFlow
            throw new IOException("Invalid directory: " + dir.getCanonicalPath());
        }
    }

    void foo13(File dir, File parent) throws IOException {
        String parentCanonical = parent.getCanonicalPath() + File.separatorChar;
        if (!dir.getCanonicalPath().startsWith(parentCanonical)) {
            throw new IOException("Invalid directory: " + dir.getCanonicalPath());
        }
    }

    void foo14(File dir, File parent) throws IOException {
        String parentCanonical = parent.getCanonicalPath() + separatorChar;
        if (!dir.getCanonicalPath().startsWith(parentCanonical)) { 
            throw new IOException("Invalid directory: " + dir.getCanonicalPath());
        }
    }

    void foo15(File dir, File parent) throws IOException {
        String parentCanonical = parent.getCanonicalPath() + File.separatorChar;
        String parentCanonical2 = parent.getCanonicalPath() + File.separatorChar;
        if (!dir.getCanonicalPath().startsWith(parentCanonical)) {
            throw new IOException("Invalid directory: " + dir.getCanonicalPath());
        }
        if (!dir.getCanonicalPath().startsWith(parentCanonical2)) {
            throw new IOException("Invalid directory: " + dir.getCanonicalPath());
        }
    }

    void foo16(File dir, File parent) throws IOException {
        String parentCanonical = parent.getCanonicalPath() + File.separator;
        if (!dir.getCanonicalPath().startsWith(parentCanonical)) {
            throw new IOException("Invalid directory: " + dir.getCanonicalPath());
        }
    }

    @SuppressWarnings({
            "IfStatementWithIdenticalBranches",
            "MismatchedStringCase",
            "UnusedAssignment",
            "ResultOfMethodCallIgnored"
    })
    void foo17(File dir, File parent, boolean branch) throws IOException {
        String parentCanonical = null;
        "test ".startsWith("somethingElse");
        if (branch) {
            parentCanonical = parent.getCanonicalPath() + File.separatorChar;
        } else {
            parentCanonical = parent.getCanonicalPath() + File.separatorChar;
        }
        if (!dir.getCanonicalPath().startsWith(parentCanonical)) {
            throw new IOException("Invalid directory: " + dir.getCanonicalPath());
        }
    }

    void foo18(File dir, File parent, boolean branch) throws IOException {
        String parentCanonical = parent.getCanonicalPath();
        if (branch) {
            parentCanonical = parent.getCanonicalPath() + File.separatorChar;
        }
        if (!dir.getCanonicalPath().startsWith(parentCanonical)) {
            throw new IOException("Invalid directory: " + dir.getCanonicalPath());
        }
    }

    void foo19(File dir, File parent) throws IOException {
        String parentCanonical = parent.getCanonicalPath() + "/potato";
        if (!dir.getCanonicalPath().startsWith(parentCanonical)) { // $hasTaintFlow
            throw new IOException("Invalid directory: " + dir.getCanonicalPath());
        }
    }

    private File cacheDir;

    InputStream foo20(String... path) {
        StringBuilder sb = new StringBuilder();
        sb.append(cacheDir.getAbsolutePath());
        for (String p : path) {
            sb.append(File.separatorChar);
            sb.append(p);
        }
        sb.append(".gz");
        String filePath = sb.toString();
        File encodedFile = new File(filePath);
        try {
            if (!encodedFile.getCanonicalPath().startsWith(cacheDir.getCanonicalPath())) { // $hasTaintFlow 
                return null;
            }
            return Files.newInputStream(encodedFile.toPath());
        } catch (Exception e) {
            return null;
        }
    }

    void foo21(File dir, File parent) throws IOException {
        String parentCanonical = parent.getCanonicalPath();
        if (!dir.getCanonicalPath().startsWith(parentCanonical + File.separator)) {
            throw new IOException("Invalid directory: " + dir.getCanonicalPath());
        }
    }

    void foo22(File dir, File dir2, File parent, boolean conditional) throws IOException {
        String canonicalPath = conditional ? dir.getCanonicalPath() : dir2.getCanonicalPath();
        if (!canonicalPath.startsWith(parent.getCanonicalPath())) { // $hasTaintFlow
            throw new IOException("Invalid directory: " + dir.getCanonicalPath());
        }
    }

    void foo23(File dir, File parent) throws IOException {
        String parentCanonical = parent.getCanonicalPath();
        if (!dir.getCanonicalPath().startsWith(parentCanonical + "/")) {
            throw new IOException("Invalid directory: " + dir.getCanonicalPath());
        }
    }

    void foo24(File dir, File parent) throws IOException {
        String parentCanonical = parent.getCanonicalPath();
        if (!dir.getCanonicalPath().startsWith(parentCanonical + '/')) {
            throw new IOException("Invalid directory: " + dir.getCanonicalPath());
        }
    }

    public void doesNotFlagOptimalSafeVersion(File dir, File parent) throws IOException {
        if (!dir.toPath().normalize().startsWith(parent.toPath())) { // Safe
            throw new IOException("Path traversal attempt: " + dir.getCanonicalPath());
        }
    }

    public void doesNotFlag() {
        "hello".startsWith("goodbye");
    }

    public void doesNotFlagBackslash(File file) throws IOException {
        // https://github.com/jenkinsci/jenkins/blob/be3cf6bffe7aa2fe2307c424fa418519f3bbd73b/core/src/main/java/hudson/util/jna/Kernel32Utils.java#L77-L77
        if (!file.getCanonicalPath().startsWith("\\\\")) {
            throw new RuntimeException("Boom");
        }
    }

}