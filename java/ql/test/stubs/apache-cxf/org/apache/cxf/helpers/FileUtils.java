package org.apache.cxf.helpers;

import java.io.File;
import java.util.List;

public class FileUtils {
    public static File createTempFile(String prefix, String suffix) {
        return null;
    }

    public static File createTempFile(String prefix, String suffix, File parentDir,
            boolean deleteOnExit) {
        return null;
    }

    public static File createTmpDir() {
        return null;
    }

    public static File createTmpDir(boolean addHook) {
        return null;
    }

    public static void delete(File f) {}

    public static void delete(File f, boolean inShutdown) {}

    public static boolean exists(File file) {
        return false;
    }

    public static File getDefaultTempDir() {
        return null;
    }

    public static List<File> getFiles(File dir, String pattern) {
        return null;
    }

    public static List<File> getFilesRecurseUsingSuffix(File dir, String suffix) {
        return null;
    }

    public static List<File> getFilesUsingSuffix(File dir, String suffix) {
        return null;
    }

    public static boolean isValidFileName(String name) {
        return false;
    }

    public static void maybeDeleteDefaultTempDir() {}

    public static void mkDir(File dir) {}

    public static List<String> readLines(File file) {
        return null;
    }

    public static void removeDir(File d) {}

    public static String stripPath(String name) {
        return null;
    }
}
