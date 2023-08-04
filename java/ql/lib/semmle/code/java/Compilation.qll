/**
 * Provides a class representing individual compiler invocations that occurred during the build.
 */

import semmle.code.FileSystem

/**
 * An invocation of the compiler. Note that more than one file may be
 * compiled per invocation. For example, this command compiles three
 * source files:
 *
 *   javac Foo.java Bar.java Baz.java
 *
 * Two things happen to each file during a compilation:
 *
 *   1. The file is compiled by a real compiler, such as javac or kotlinc.
 *   2. The file is parsed by the CodeQL front-end.
 *   3. The parsed representation is converted to database tables by
 *      the CodeQL extractor.
 *
 * This class provides CPU and elapsed time information for steps 2 and 3,
 * but not for step 1.
 */
class Compilation extends @compilation {
  /** Gets a textual representation of this element. */
  string toString() {
    exists(string name |
      compilations(this, _, _, name) and
      result = "<compilation " + name + ">"
    )
  }

  /** Gets a file compiled during this invocation. */
  File getAFileCompiled() { result = this.getFileCompiled(_) }

  /** Gets the `i`th file compiled during this invocation. */
  File getFileCompiled(int i) { compilation_compiling_files(this, i, result) }

  /** Holds if the `i`th file during this invocation was successfully extracted. */
  predicate fileCompiledSuccessful(int i) { compilation_compiling_files_completed(this, i, 0) }

  /** Holds if the `i`th file during this invocation had recoverable extraction errors. */
  predicate fileCompiledRecoverableErrors(int i) {
    compilation_compiling_files_completed(this, i, 1)
  }

  /** Holds if the `i`th file during this invocation had non-recoverable extraction errors. */
  predicate fileCompiledNonRecoverableErrors(int i) {
    compilation_compiling_files_completed(this, i, 2)
  }

  /**
   * Gets the amount of CPU time spent processing file number `i` in the
   * front-end.
   */
  float getFrontendCpuSeconds(int i) { compilation_time(this, i, 1, result) }

  /**
   * Gets the amount of elapsed time while processing file number `i` in the
   * front-end.
   */
  float getFrontendElapsedSeconds(int i) { compilation_time(this, i, 2, result) }

  /**
   * Gets the amount of CPU time spent processing file number `i` in the
   * extractor.
   */
  float getExtractorCpuSeconds(int i) { compilation_time(this, i, 3, result) }

  /**
   * Gets the amount of elapsed time while processing file number `i` in the
   * extractor.
   */
  float getExtractorElapsedSeconds(int i) { compilation_time(this, i, 4, result) }

  /**
   * Gets an argument passed to the extractor on this invocation.
   */
  string getAnArgument() { result = this.getArgument(_) }

  /**
   * Gets the `i`th argument passed to the extractor on this invocation.
   */
  string getArgument(int i) { compilation_args(this, i, result) }

  /**
   * Gets an expanded argument passed to the extractor on this invocation.
   */
  string getAnExpandedArgument() { result = this.getExpandedArgument(_) }

  /**
   * Gets the `i`th expanded argument passed to the extractor on this invocation.
   */
  string getExpandedArgument(int i) { compilation_expanded_args(this, i, result) }

  /**
   * Gets the total amount of CPU time spent processing all the files in the
   * compiler.
   */
  float getCompilerCpuSeconds() { compilation_compiler_times(this, result, _) }

  /**
   * Gets the total amount of elapsed time while processing all the files in
   * the compiler.
   */
  float getCompilerElapsedSeconds() { compilation_compiler_times(this, _, result) }

  /**
   * Gets the total amount of CPU time spent processing all the files in the
   * front-end and extractor.
   */
  float getTotalCpuSeconds() { compilation_finished(this, result, _, _) }

  /**
   * Gets the total amount of elapsed time while processing all the files in
   * the front-end and extractor.
   */
  float getTotalElapsedSeconds() { compilation_finished(this, _, result, _) }

  /**
   * Holds if this is a compilation of Java code.
   */
  predicate isJava() { this instanceof @javacompilation }

  /**
   * Holds if this is a compilation of Kotlin code.
   */
  predicate isKotlin() { this instanceof @kotlincompilation }

  /**
   * Holds if extraction for the compilation started.
   */
  predicate extractionStarted() { compilation_started(this) }

  /**
   * Holds if the extractor terminated normally. Terminating with an exit
   * code indicating that an error occurred is considered normal
   * termination, but crashing due to something like a segfault is not.
   */
  predicate normalTermination() { compilation_finished(this, _, _, _) }

  /**
   * Holds if the extractor succeeded without error.
   */
  predicate extractionSuccessful() { compilation_finished(this, _, _, 0) }

  /**
   * Holds if the extractor encountered recoverable errors.
   */
  predicate recoverableErrors() { compilation_finished(this, _, _, 1) }

  /**
   * Holds if the extractor encountered non-recoverable errors.
   */
  predicate nonRecoverableErrors() { compilation_finished(this, _, _, 2) }

  /**
   * Gets the piece of compilation information with the given key, if any.
   */
  string getInfo(string key) { compilation_info(this, key, result) }
}
