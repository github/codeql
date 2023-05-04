import java.io.File;
import java.io.IOException;

public class Test {

    private static final File vulnerableAssigned;

    static {
        File temp = null;
        try {
            temp = File.createTempFile("test", "directory");
            temp.delete();
            temp.mkdir();
        } catch(IOException e) {
            System.out.println("Could not create temporary directory");
            System.exit(-1);
        }
        vulnerableAssigned = temp;
    }

    static File vulnerable() throws IOException {
        File temp = File.createTempFile("test", "directory");
        temp.delete();
        temp.mkdir();
        return temp;
    }

    static File notVulnerableToHijacking() throws IOException {
        File temp = File.createTempFile("test", "directory");
        temp.mkdir();
        return temp;
    }

    static File safe() throws IOException {
        File temp = File.createTempFile("test", "directory");
        temp.delete();
        if (temp.mkdir()) {
            return temp;
        } else {
            throw new RuntimeException("Failed to create directory");
        }
    }

    static File safe2() throws IOException {
        File temp = File.createTempFile("test", "directory");
        temp.delete();
        boolean didMkdirs = temp.mkdirs();
        if (didMkdirs) {
            return temp;
        } else {
            throw new RuntimeException("Failed to create directory");
        }
    }

    static File safe3() throws IOException {
        File temp = File.createTempFile("test", "directory");
        temp.delete();
        if (!(temp.mkdirs())) {
            throw new RuntimeException("Failed to create directory");
        }
        return temp;
    }

    static File safe4() throws IOException {
        boolean success = true;
        File temp = File.createTempFile("test", "directory");
        success &= temp.delete();
        success &= temp.mkdir();
        if (!success) {
            throw new RuntimeException("Failed to create directory");
        }
        return temp;
    }

    static File safe5() throws IOException {
        boolean success = true;
        File temp = File.createTempFile("test", "directory");
        success &= temp.delete();
        success &= temp.mkdir();
        if (success) {
            return temp;
        } else {
            throw new RuntimeException("Failed to create directory");
        }
    }

    static File safe6() throws IOException {
        File temp = File.createTempFile("test", "directory");
        if (temp.delete() && temp.mkdir()) {
            return temp;
        } else {
            throw new RuntimeException("Failed to create directory");
        }
    }

    static File safe7() throws IOException {
        File temp = File.createTempFile("test", "directory");
        if (!temp.delete() || !temp.mkdir()) {
            throw new IOException("Can not convert temporary file " + temp + "to directory");
        } else {
            return temp;
        }
    }

    /**
     * When `isDirectory` is true, create a temporary directory, else create a temporary file.
     */
    static File safe8(boolean isDirectory) throws IOException {
        File temp = File.createTempFile("test", "directory");
        if (isDirectory && (!temp.delete() || !temp.mkdir())) {
            throw new IOException("Can not convert temporary file " + temp + "to directory");
        } else {
            return temp;
        }
    }

    static File safe9() throws IOException {
        File temp = File.createTempFile("test", "directory");
        if (!temp.delete()) {
            throw new IOException("Could not delete temp file: " + temp.getAbsolutePath());
        }
        if (!temp.mkdir()) {
            throw new IOException("Could not create temp directory: " + temp.getAbsolutePath());
        }
        return temp;
    }

    static File vulnerable2() throws IOException {
        File temp = File.createTempFile("test", "directory", new File(System.getProperty("java.io.tmpdir")));
        temp.delete();
        temp.mkdir();
        return temp;
    }

    static File safe10() throws IOException {
        File temp = File.createTempFile("test", "directory", new File(System.getProperty("user.dir")));
        temp.delete();
        temp.mkdir();
        return temp;
    }

    static File vulnerable3() throws IOException {
        File temp = File.createTempFile(
            "test", 
            "directory", 
            new File(System.getProperty("java.io.tmpdir")).getAbsoluteFile()
        );
        temp.delete();
        temp.mkdir();
        return temp;
    }

    static File safe11() throws IOException {
        File temp = null;
        while (true) {
            temp = File.createTempFile("test", "directory");
            if (temp.delete() && temp.mkdir()) {
                break;
            }
        }
        return temp;
    }

    File safe12temp;
    File safe12() throws IOException {
        if (safe12temp == null) {
            File safe = null;
            while (true) {
                safe = File.createTempFile("test", "directory");
                if (safe.delete() && safe.mkdir()) {
                    break;
                }
            }
            safe12temp = safe;
        }
        return safe12temp;
    }

    File safe13() throws IOException {
        File temp = File.createTempFile("test", "directory");
        temp.delete();
        if (temp.mkdir()) {
            return temp;
        } else {
            throw new IOException(temp.getAbsolutePath() + " could not be created");
        }
    }

    File safe14() throws IOException {
        File temp = File.createTempFile("test", "directory");
        temp.delete();
        if (temp.mkdir()) {
            return temp;
        } else {
            throw new IOException(temp.getAbsolutePath());
        }
    }

    File safe15() throws IOException {
        File temp = File.createTempFile("test", "directory");
        temp.delete();
        if (temp.mkdir()) {
            return temp;
        } else {
            final String absolutePath = temp.getAbsolutePath();
            throw new IOException(absolutePath);
        }
    }

    File vulnerable4() throws IOException {
        File temp = new File(System.getProperty("java.io.tmpdir"));
        ensureDirectory(temp);
        File workDir = File.createTempFile("test", "directory", temp);
        if (!workDir.delete()) {
            throw new IOException("Could not delete temp file: " + workDir.getAbsolutePath());
        }
        ensureDirectory(workDir);
        return workDir;
    }
    
    private static void ensureDirectory(File dir) throws IOException {
        if (!dir.mkdirs() && !dir.isDirectory()) {
            throw new IOException("Mkdirs failed to create " + dir.toString());
        }
    }

    static File vulnerable5() throws IOException {
        File temp = File.createTempFile("test", "directory", null);
        temp.delete();
        temp.mkdir();
        return temp;
    }

    File vulnerable6() throws IOException {
        File temp = new File(System.getProperty("java.io.tmpdir"));
        ensureDirectoryReversed(temp);
        File workDir = File.createTempFile("test", "directory", temp);
        if (!workDir.delete()) {
            throw new IOException("Could not delete temp file: " + workDir.getAbsolutePath());
        }
        ensureDirectoryReversed(workDir);
        return workDir;
    }

    private static void ensureDirectoryReversed(File dir) throws IOException {
        // If the directory already exists, don't create it. If it's not, create it.
        // Note: this is still vulnerable because the race condition still exists
        if (!(dir.isDirectory() || dir.mkdirs())) {
            throw new IOException("Mkdirs failed to create " + dir.toString());
        }
    }

    File vulnerable7() throws IOException {
        File temp = new File(System.getProperty("java.io.tmpdir"));
        mkdirsWrapper(temp);
        File workDir = File.createTempFile("test", "directory", temp);
        workDir.delete();
        mkdirsWrapper(workDir);
        return workDir;
    }

    static void mkdirsWrapper(File file) {
        file.mkdirs();
    }

    File safe16() throws IOException {
        File temp = new File(System.getProperty("java.io.tmpdir"));
        mkdirsWrapperSafe(temp);
        File workDir = File.createTempFile("test", "directory", temp);
        workDir.delete();
        mkdirsWrapperSafe(workDir);
        return workDir;
    }

    static void mkdirsWrapperSafe(File file) throws IOException {
        if(!file.mkdirs()) {
            throw new IOException("Mkdirs failed to create " + file.toString());
        }
    }

    File vulnerable8() throws IOException {
        File temp = new File(System.getProperty("java.io.tmpdir"));
        mkdirsWrapper2(temp);
        File workDir = File.createTempFile("test", "directory", temp);
        workDir.delete();
        mkdirsWrapper2(workDir);
        return workDir;
    }

    static void mkdirsWrapper2(File file) {
        if (file.exists()) return;
        file.mkdirs();
    }

    File vulnerable9() throws IOException {
        File temp = new File(System.getProperty("java.io.tmpdir"));
        mkdirsWrapper3(temp);
        File workDir = File.createTempFile("test", "directory", temp);
        workDir.delete();
        mkdirsWrapper3(workDir);
        return workDir;
    }

    static void mkdirsWrapper3(File file) throws IOException {
        if (file.exists()) return; // Vulnerable path
        if (!file.mkdirs()) {
            throw new IOException("Mkdirs failed to create " + file.toString());
        }
    }

    File vulnerable10() throws IOException {
        File temp = new File(System.getProperty("java.io.tmpdir"));
        temp.mkdirs();
        File workDir = File.createTempFile("test", "directory", temp);
        deleteWrapper(workDir);
        workDir.mkdirs();
        return workDir;
    }

    static void deleteWrapper(File file) {
        file.delete();
    }
}
