FileOutputStream fos = null;
try {
	fos = new FileOutputStream(new File("may_not_exist.txt"));
} catch (FileNotFoundException e) {
	// ask the user and try again
} catch (IOException e) {
	// more serious, abort
} finally {
	if (fos!=null) { try { fos.close(); } catch (IOException e) { /*ignore*/ } }
}