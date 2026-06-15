package org.example;

import java.nio.file.StandardCopyOption;
import java.util.Enumeration;
import java.io.IOException;
import java.util.zip.*;
import java.util.zip.ZipEntry;
import java.io.File;
import java.nio.file.Files;


class BadExample {
    public static void ZipInputStreamUnSafe(String filename) throws IOException {
        File f = new File(filename);
        try (ZipFile zipFile = new ZipFile(f)) {
            Enumeration<? extends ZipEntry> entries = zipFile.entries();

            while (entries.hasMoreElements()) {
                ZipEntry ze = entries.nextElement();
                File out = new File("./tmp/tmp.txt");
                Files.copy(zipFile.getInputStream(ze), out.toPath(), StandardCopyOption.REPLACE_EXISTING);
            }
        }
    }
}