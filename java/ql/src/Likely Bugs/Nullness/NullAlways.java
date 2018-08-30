public void createDir(File dir) {
	if (dir != null || !dir.exists()) // BAD
		dir.mkdir();
}

public void createDir(File dir) {
	if (dir != null && !dir.exists()) // GOOD
		dir.mkdir();
}
