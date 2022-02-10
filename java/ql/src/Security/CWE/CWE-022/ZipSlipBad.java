void writeZipEntry(ZipEntry entry, File destinationDir) {
    File file = new File(destinationDir, entry.getName());
    FileOutputStream fos = new FileOutputStream(file); // BAD
    // ... write entry to fos ...
}



void writeJarEntry(JarEntry entry, File destinationDir) {
    File file = new File(destinationDir, entry.getName());
    FileOutputStream fost = new FileOutputStream(file); // BAD
    // ... write entry to fost ...
}
  
