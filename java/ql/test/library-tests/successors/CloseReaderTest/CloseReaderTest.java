package successors;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;

public class CloseReaderTest {
	public static String readPassword(File keyFile)
	{
		// TODO: use Console.readPassword() when it's available.
		System.out.print("Enter password for " + keyFile
				+ " (password will not be hidden): ");
		System.out.flush();
		BufferedReader stdin = new BufferedReader(new InputStreamReader(
				System.in));
		try
		{
			return stdin.readLine();
		} catch (IOException ex)
		{
			return null;
		}
	}
}
