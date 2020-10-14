import java.io.File;

public class Test {

    static File vulnerable() {
        File temp = File.createTempFile("test", "directory");
        temp.delete();
        temp.mkdir();
        return temp;
    }

    static File notVulnerableToHijacking() {
        File temp = File.createTempFile("test", "directory");
        temp.mkdir();
        return temp;
    }

    static File safe() {
        File temp = File.createTempFile("test", "directory");
        temp.delete();
        if (temp.mkdir()) {
            return temp;
        } else {
            throw new RuntimeException("Failed to create directory");
        }
    }

    static File safe2() {
        File temp = File.createTempFile("test", "directory");
        temp.delete();
        boolean didMkdirs = temp.mkdirs();
        if (didMkdirs) {
            return temp;
        } else {
            throw new RuntimeException("Failed to create directory");
        }
    }
    
}
