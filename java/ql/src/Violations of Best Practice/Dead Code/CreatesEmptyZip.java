class Archive implements Closeable
{
	private ZipOutputStream zipStream;

	public Archive(File zip) throws IOException {
		OutputStream stream = new FileOutputStream(zip);
		stream = new BufferedOutputStream(stream);
		zipStream = new ZipOutputStream(stream);
	}

	public void archive(String name, byte[] content) throws IOException {
		ZipEntry entry = new ZipEntry(name);
		zipStream.putNextEntry(entry);
		// Missing call to 'write'
		zipStream.closeEntry();
	}

	public void close() throws IOException {
		zipStream.close();
	}
}