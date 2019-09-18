package com.semmle.js.extractor;

import java.io.IOException;

/** Generic extractor interface. */
public interface IExtractor {
  /**
   * Extract a snippet of code whose textual information is provided by the given {@link
   * TextualExtractor}, and return information about the number of lines of code and the number of
   * lines of comments extracted.
   */
  public LoCInfo extract(TextualExtractor textualExtractor) throws IOException;
}
