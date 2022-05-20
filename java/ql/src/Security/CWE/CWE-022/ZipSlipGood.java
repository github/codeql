void writeZipEntry(ZipEntry entry, File destinationDir) {
    File file = new File(destinationDir, entry.getName());
    if (!file.toPath().normalize().startsWith(destinationDir.toPath()))
        throw new Exception("Bad zip entry");
    FileOutputStream fos = new FileOutputStream(file); // OK
    // ... write entry to fos ...
}
