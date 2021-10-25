/**
 * A JavaDoc comment
 * with multiple lines.
 */
class Test {
	/** A JavaDoc comment with a single line. */
	void m() {
		// a single-line comment
		// another single-line comment
	}

	/* A block comment
	 * with multiple lines.
	 */

	/* A block comment with a single line. */

	// an end-of-line comment with a spurious trailing comment marker */
	// an end-of-line comment with trailing whitespace        
	//an end-of-line comment without a leading space
	void test() {} // an end-of-line comment with preceding code
}
