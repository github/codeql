package com.semmle.js.extractor.trapcache;

import com.semmle.js.extractor.ExtractorConfig;
import com.semmle.js.extractor.FileExtractor.FileType;
import java.io.File;

/** A dummy TRAP cache that does not cache anything. */
public class DummyTrapCache implements ITrapCache {
  @Override
  public File lookup(String source, ExtractorConfig config, FileType type) {
    return null;
  }
}
