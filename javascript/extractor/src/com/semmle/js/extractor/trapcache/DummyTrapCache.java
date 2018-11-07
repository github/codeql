package com.semmle.js.extractor.trapcache;

import java.io.File;

import com.semmle.js.extractor.ExtractorConfig;
import com.semmle.js.extractor.FileExtractor.FileType;

/**
 * A dummy TRAP cache that does not cache anything.
 */
public class DummyTrapCache implements ITrapCache {
	@Override
	public File lookup(String source, ExtractorConfig config, FileType type) {
		return null;
	}
}
