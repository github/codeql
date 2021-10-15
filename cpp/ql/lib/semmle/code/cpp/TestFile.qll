/**
 * Provides classes for identifying files that contain test cases. It is often
 * desirable to exclude these files from analysis.
 */

import semmle.code.cpp.File

/**
 * The `gtest/gtest.h` file.
 */
private class GoogleTestHeader extends File {
  GoogleTestHeader() {
    getBaseName() = "gtest.h" and
    getParentContainer().getBaseName() = "gtest"
  }
}

/**
 * A test using the Google Test library.
 */
private class GoogleTest extends MacroInvocation {
  GoogleTest() {
    // invocation of a macro from Google Test.
    this.getMacro().getFile() instanceof GoogleTestHeader
  }
}

/**
 * The `boost/test` directory.
 */
private class BoostTestFolder extends Folder {
  BoostTestFolder() {
    getBaseName() = "test" and
    getParentContainer().getBaseName() = "boost"
  }
}

/**
 * A test using the Boost Test library.
 */
private class BoostTest extends MacroInvocation {
  BoostTest() {
    // invocation of a macro from Boost Test.
    this.getMacro().getFile().getParentContainer+() instanceof BoostTestFolder
  }
}

/**
 * The `cppunit` directory.
 */
private class CppUnitFolder extends Folder {
  CppUnitFolder() { getBaseName() = "cppunit" }
}

/**
 * A class from the `cppunit` directory.
 */
private class CppUnitClass extends Class {
  CppUnitClass() {
    getFile().getParentContainer+() instanceof CppUnitFolder and
    getNamespace().getParentNamespace*().getName() = "CppUnit"
  }
}

/**
 * A test using the CppUnit library.
 */
private class CppUnitTest extends Element {
  CppUnitTest() {
    // class with a base class from cppunit.
    this.(Class).getABaseClass*() instanceof CppUnitClass and
    // class itself is not a part of cppunit.
    not this instanceof CppUnitClass
    or
    // any member function of a test is also test code
    this.(Function).getDeclaringType() instanceof CppUnitTest
  }
}

/**
 * A file that contains one or more test cases.
 */
class TestFile extends File {
  TestFile() {
    exists(GoogleTest test | test.getFile() = this) or
    exists(BoostTest test | test.getFile() = this) or
    exists(CppUnitTest test | test.getFile() = this)
  }
}
