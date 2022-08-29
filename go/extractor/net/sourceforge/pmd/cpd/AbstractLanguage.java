package net.sourceforge.pmd.cpd;

/*
 * This is a stub definition for pmd's AbstractLanguage class
 * including only the API used by the GoLanguage class.
 */

public abstract class AbstractLanguage {

  public AbstractLanguage(String... extensions) {}

  public abstract Tokenizer getTokenizer(boolean fuzzyMatch);
}
