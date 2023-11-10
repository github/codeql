package com.semmle.js.extractor.test;

import org.junit.runner.RunWith;
import org.junit.runners.Suite;
import org.junit.runners.Suite.SuiteClasses;

@RunWith(Suite.class)
@SuiteClasses({
  JSXTests.class,
  NodeJSDetectorTests.class,
  TrapTests.class,
  ObjectRestSpreadTests.class,
  ClassPropertiesTests.class,
  FunctionSentTests.class,
  DecoratorTests.class,
  ExportExtensionsTests.class,
  AutoBuildTests.class,
  RobustnessTests.class,
  NumericSeparatorTests.class
})
public class AllTests {}
