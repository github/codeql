import java.io.File;
import java.io.FileReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.nio.file.attribute.PosixFilePermission;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.EnumSet;
import java.util.LinkedHashSet;
import java.util.Set;

class Test {
	public static void main(String[] args) throws IOException {
		// Using the File API
		File f = new File("file");
		setWorldWritable(f);
		readFile(f);

		// Using the Path API
		Path p = Paths.get("file");
		Set<PosixFilePermission> filePermissions = EnumSet.of(PosixFilePermission.OTHERS_WRITE);
		Files.setPosixFilePermissions(p, filePermissions);
		Files.readAllLines(p);

		// Convert file to path
		File f2 = new File("file2");
		Set<PosixFilePermission> file2Permissions = new LinkedHashSet<>();
		file2Permissions.add(PosixFilePermission.OTHERS_WRITE);
		Files.setPosixFilePermissions(Paths.get(f2.getCanonicalPath()), file2Permissions);
		new FileInputStream(f2);
	}

	public static void readFile(File f) {
		new FileReader(f);
	}

	public static void setWorldWritable(File f) {
		f.setWritable(true, false);
	}
}