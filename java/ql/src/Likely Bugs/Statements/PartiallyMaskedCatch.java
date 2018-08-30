FileInputStream fis = null;
try {
	fis = new FileInputStream(new File("may_not_exist.txt"));
	// read from input stream
} catch (FileNotFoundException e) {
	// ask the user and try again
} catch (IOException e) {
	// more serious, abort
} finally {
	if (fis!=null) { try { fis.close(); } catch (IOException e) { /*ignore*/ } }
}