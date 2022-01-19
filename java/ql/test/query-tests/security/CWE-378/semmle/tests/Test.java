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
    
}
