import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

public class TestTryWithResources {
	public static void main(String[] args) throws IOException {
		try (FileInputStream fis = new FileInputStream(args[0]);
			FileOutputStream fos = new FileOutputStream(args[1])) {
			System.out.println("worked");
		} catch (FileNotFoundException e) {
			System.out.println("file not found");
		} finally {
			System.out.println("finally");
		}
	}
}