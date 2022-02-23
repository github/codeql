import java.nio.file.FileSystems;
import java.nio.file.Path;

import org.apache.commons.lang3.SystemUtils;

public class Test {
    void test() {
        if (System.getProperty("os.name").contains("Windows")) {
            
        }

        if (System.getProperty("os.name").toLowerCase().contains("windows")) {
            
        }

        if (System.getProperty("os.name").contains("Linux")) {
            
        }

        if (System.getProperty("os.name").contains("Mac OS X")) {
            
        }

        if (System.getProperty("os.name").toLowerCase().contains("mac")) {
            
        }

        if (Path.of("whatever").getFileSystem().supportedFileAttributeViews().contains("posix")) {

        }

        if (FileSystems.getDefault().supportedFileAttributeViews().contains("posix")) {

        }

        if (SystemUtils.IS_OS_WINDOWS) {

        }

        if (SystemUtils.IS_OS_UNIX) {

        }
    }
}
