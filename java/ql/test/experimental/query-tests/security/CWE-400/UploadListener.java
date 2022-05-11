package test.cwe400.cwe.examples;

import java.io.Serializable;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.fileupload2.ProgressListener;

public class UploadListener implements ProgressListener, Serializable {
	protected int slowUploads = 0;
	private Long bytesRead = 0L;
	private long contentLength = 0L;

	public UploadListener(int sleepMilliseconds, long requestSize) {
		slowUploads = sleepMilliseconds;
		contentLength = requestSize;
	}

	public long getPercent() {
		return contentLength != 0 ? bytesRead * 100 / contentLength : 0;
	}

	public long getBytesRead() {
		return bytesRead;
	}

	public void update(long done, long total, int item) {
		bytesRead = done;
		contentLength = total;

		// Just a way to slow down the upload process and see the progress bar in fast networks.
		if (slowUploads > 0 && done < total) {
			try {
				Thread.sleep(slowUploads);
			} catch (Exception e) {
			}
		}
	}
}
