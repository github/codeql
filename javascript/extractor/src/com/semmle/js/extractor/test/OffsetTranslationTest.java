package com.semmle.js.extractor.test;

import com.semmle.js.extractor.OffsetTranslation;
import org.junit.Assert;
import org.junit.Test;

public class OffsetTranslationTest {
  @Test
  public void testBasic() {
    OffsetTranslation table = new OffsetTranslation();
    table.set(0, 10);
    table.set(100, 250);
    Assert.assertEquals(10, table.get(0));
    Assert.assertEquals(15, table.get(5));
    Assert.assertEquals(85, table.get(75));
    Assert.assertEquals(109, table.get(99));
    Assert.assertEquals(250, table.get(100));
    Assert.assertEquals(251, table.get(101));
  }

  @Test
  public void testLookupBefore() {
    OffsetTranslation table = new OffsetTranslation();
    table.set(0, 10);
    table.set(100, 250);
    Assert.assertEquals(9, table.get(-1));
  }

  @Test
  public void testIdentity() {
    OffsetTranslation table = new OffsetTranslation();
    table.set(0, 0);
    Assert.assertEquals(0, table.get(0));
    Assert.assertEquals(75, table.get(75));
  }

  @Test
  public void testDuplicateAnchor() {
    OffsetTranslation table = new OffsetTranslation();
    table.set(0, 0);
    table.set(10, 100);
    table.set(10, 100);
    table.set(20, 150);
    Assert.assertEquals(1, table.get(1));
    Assert.assertEquals(100, table.get(10));
    Assert.assertEquals(101, table.get(11));
    Assert.assertEquals(150, table.get(20));
    Assert.assertEquals(151, table.get(21));
  }
}
