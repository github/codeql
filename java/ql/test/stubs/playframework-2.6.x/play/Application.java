/*
 * Copyright (C) 2009-2016 Lightbend Inc. <https://www.lightbend.com>
 */
package play;

import java.io.File;
import java.io.InputStream;
import java.net.URL;

public interface Application {

  default File path() {
    return null;
  }

  default ClassLoader classloader() {
    return null;
  }

  default File getFile(String relativePath) {
    return null;
  }

  default URL resource(String relativePath) {
    return null;
  }

  default InputStream resourceAsStream(String relativePath) {
    return null;
  }
}
