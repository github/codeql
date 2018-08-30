// Semmle test case for CWE-22: Improper Limitation of a Pathname to a Restricted Directory ('Path Traversal')
// http://cwe.mitre.org/data/definitions/22.html
package test.cwe22.semmle.tests;




import java.io.IOException;
import java.io.File;
import java.net.InetAddress;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.FileSystems;


class Test {
	void doGet1(InetAddress address)
		throws IOException {
			String temp = address.getHostName();
			File file;
			Path path;
			
			// BAD: construct a file path with user input
			file = new File(temp);
			
			// BAD: construct a path with user input
			path = Paths.get(temp);
					
			// BAD: construct a path with user input
			path = FileSystems.getDefault().getPath(temp);
	}
	
	void doGet2(InetAddress address)
		throws IOException {
			String temp = address.getHostName();
			File file;

			// GOOD: check string is safe
			if(isSafe(temp))
				file = new File(temp);
	}
	
	void doGet3(InetAddress address)
		throws IOException {
			String temp = address.getHostName();
			File file;

			// FALSE NEGATIVE: inadequate check - fails to account
			// for '.'s
			if(isSortOfSafe(temp))
				file = new File(temp);
	}

	boolean isSafe(String pathSpec) {
		// no file separators
		if (pathSpec.contains(File.separator))
			return false;
		// at most one dot
		int indexOfDot = pathSpec.indexOf('.');
		if (indexOfDot != -1 && pathSpec.indexOf('.', indexOfDot + 1) != -1)
			return false;
		return true;
	}
	
	boolean isSortOfSafe(String pathSpec) {
		// no file separators
		if (pathSpec.contains(File.separator))
			return false;
		return true;
	}
}
