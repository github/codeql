
import java.io.File;
import java.nio.file.FileSystems;
import java.nio.file.Path;

import org.apache.commons.lang3.SystemUtils;

public class Test {
    /**
     * Should only be called on windows
     */
    private void onlyOnWindows() {}
    
    /**
     * Should only be called on unix-like systems
     */
    private void onlyOnUnix() {}

    void testWindows() {
        if (System.getProperty("os.name").contains("Windows")) {
            onlyOnWindows();
        }

        if (System.getProperty("os.name").toLowerCase().contains("windows")) {
            onlyOnWindows();
        }

        if (System.getProperty("os.name").toLowerCase().contains("window")) {
            onlyOnWindows();
        }

        if (System.getProperty("os.name").toUpperCase().contains("WINDOWS")) {
            onlyOnWindows();
        }

        if (SystemUtils.IS_OS_WINDOWS) {
            onlyOnWindows();
        } else {
            onlyOnUnix();
        }

        if (SystemUtils.IS_OS_WINDOWS_XP) {
            onlyOnWindows();
        } else {
            // Might be another version of windows
        }

        if (File.pathSeparatorChar == ';') {
            onlyOnWindows();
        }

        if (File.pathSeparator == ";") {
            onlyOnWindows();
        }

        if (File.separatorChar == '\\') {
            onlyOnWindows();
        }

        if (File.separator == "\\") {
            onlyOnWindows();
        }

        if (System.getProperty("path.separator").equals(";")) {
            onlyOnWindows();
        }
    }

    void testUnix() {
        if (Path.of("whatever").getFileSystem().supportedFileAttributeViews().contains("posix")) {
            onlyOnUnix();
        }

        if (FileSystems.getDefault().supportedFileAttributeViews().contains("posix")) {
            onlyOnUnix();
        }

        if (SystemUtils.IS_OS_UNIX) {
            onlyOnUnix();
        } else {
            // Reasonable assumption, maybe not 100% accurate, but it's 'good enough'
            onlyOnWindows();
        }

        if (File.pathSeparatorChar == ':') {
            onlyOnUnix();
        }

        if (File.pathSeparator == ":") {
            onlyOnUnix();
        }

        if (File.separatorChar == '/') {
            onlyOnUnix();
        }

        if (File.separator == "/") {
            onlyOnUnix();
        }

        if (System.getProperty("path.separator").equals(":")) {
            onlyOnUnix();
        }
    }

    void testLinux() {
        if (System.getProperty("os.name").toLowerCase().contains("linux")) {
            onlyOnUnix();
        }

        if (System.getProperty("os.name").contains("Linux")) {
            onlyOnUnix();
        }

        if (SystemUtils.IS_OS_LINUX) {
            onlyOnUnix();
        } else {
            // Might be another different unix-like system, so this can't be `onlyOnWindows()`.
        }

        if (!SystemUtils.IS_OS_LINUX) {
            // Might be another different unix-like system, so this can't be `onlyOnWindows()`.
        } else {
            onlyOnUnix();
        }
    }

    void testMacOs() {
        if (System.getProperty("os.name").contains("Mac OS X")) {
            onlyOnUnix(); 
         }

         if (System.getProperty("os.name").toLowerCase().contains("mac")) {
            onlyOnUnix();
        }

         if (SystemUtils.IS_OS_MAC) {
            onlyOnUnix();
         } else {
            // Can't assume this is windows, it could be another unix-like OS
         }

         if (SystemUtils.IS_OS_MAC_OSX_MOJAVE) {
             onlyOnUnix();
         }
    }
}
