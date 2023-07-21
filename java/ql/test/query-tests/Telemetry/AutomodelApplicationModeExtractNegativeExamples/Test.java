package com.github.codeql.test;

import java.nio.ByteBuffer;

class AutomodelApplicationModeExtractNegativeExamples {
	public static ByteBuffer getBuffer(int size) {
		return ByteBuffer // negative example, modeled as a neutral model
		  .allocate(size); // negative example, modeled as a neutral model
	}
}
