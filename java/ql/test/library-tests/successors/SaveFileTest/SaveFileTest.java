package successors;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;


public class SaveFileTest {
	public void saveFile(String path, String contentType,
			long size, InputStream is) throws FileNotFoundException,
			IOException
	{

		String savePath = path;
		if (path.startsWith("/"))
		{
			savePath = path.substring(1);
		}

		// make sure uploads area exists for this weblog
		File dirPath = new File("foo");
		File saveFile = new File(dirPath.getAbsolutePath() + File.separator
				+ savePath);

		byte[] buffer = new byte[8192];
		int bytesRead = 0;
		OutputStream bos = null;
		try
		{
			bos = new FileOutputStream(saveFile);
			while ((bytesRead = is.read(buffer, 0, 8192)) != -1)
			{
				bos.write(buffer, 0, bytesRead);
			}

			System.out.println("The file has been written to ["
					+ saveFile.getAbsolutePath() + "]");
		} catch (Exception e)
		{
			throw new IOException("ERROR uploading file", e);
		} finally
		{
			try
			{
				bos.flush();
				bos.close();
			} catch (Exception ignored)
			{
			}
		}

	}
}
