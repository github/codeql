// Generated automatically from software.amazon.awssdk.core.io.SdkFilterInputStream for testing
// purposes

package software.amazon.awssdk.core.io;

import java.io.ByteArrayInputStream;
import java.io.FilterInputStream;
import java.io.InputStream;
import software.amazon.awssdk.core.internal.io.Releasable;

public class SdkFilterInputStream extends FilterInputStream implements Releasable {
  protected SdkFilterInputStream() {
    super(new ByteArrayInputStream("UTF-8".getBytes()));
  }

  protected SdkFilterInputStream(InputStream p0) {
    super(new ByteArrayInputStream("UTF-8".getBytes()));
  }

  protected final void abortIfNeeded() {}

  protected void abort() {}

  public boolean markSupported() {
    return false;
  }

  public int available() {
    return 0;
  }

  public int read() {
    return 0;
  }

  public int read(byte[] p0, int p1, int p2) {
    return 0;
  }

  public long skip(long p0) {
    return 0;
  }

  public void close() {}

  public void mark(int p0) {}

  public void release() {}

  public void reset() {}
}
