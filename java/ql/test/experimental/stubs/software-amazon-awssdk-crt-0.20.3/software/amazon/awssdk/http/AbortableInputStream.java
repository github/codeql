// Generated automatically from software.amazon.awssdk.http.AbortableInputStream for testing
// purposes

package software.amazon.awssdk.http;

import java.io.ByteArrayInputStream;
import java.io.FilterInputStream;
import java.io.InputStream;
import software.amazon.awssdk.http.Abortable;

public class AbortableInputStream extends FilterInputStream implements Abortable {
  protected AbortableInputStream() {
    super(new ByteArrayInputStream("UTF-8".getBytes()));
  }

  public InputStream delegate() {
    return null;
  }

  public static AbortableInputStream create(InputStream p0) {
    return null;
  }

  public static AbortableInputStream create(InputStream p0, Abortable p1) {
    return null;
  }

  public static AbortableInputStream createEmpty() {
    return null;
  }

  public void abort() {}
}
