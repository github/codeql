package p;

import java.util.Arrays;
import java.util.Objects;

public final class Joiner {
  private final String prefix;
  private final String delimiter;
  private final String suffix;
  private String[] elts;
  private int size;
  private int len;
  private String emptyValue;

  // summary=p;Joiner;false;Joiner;(CharSequence);;Argument[0];Argument[this];taint;df-generated
  // contentbased-summary=p;Joiner;false;Joiner;(CharSequence);;Argument[0];Argument[this].SyntheticField[p.Joiner.delimiter];taint;dfc-generated
  public Joiner(CharSequence delimiter) {
    this(delimiter, "", "");
  }

  // summary=p;Joiner;false;Joiner;(CharSequence,CharSequence,CharSequence);;Argument[0];Argument[this];taint;df-generated
  // summary=p;Joiner;false;Joiner;(CharSequence,CharSequence,CharSequence);;Argument[1];Argument[this];taint;df-generated
  // summary=p;Joiner;false;Joiner;(CharSequence,CharSequence,CharSequence);;Argument[2];Argument[this];taint;df-generated
  // contentbased-summary=p;Joiner;false;Joiner;(CharSequence,CharSequence,CharSequence);;Argument[0];Argument[this].SyntheticField[p.Joiner.delimiter];taint;dfc-generated
  // No content based summaries for prefix and suffix as they are "dead" synthetic fields.
  public Joiner(CharSequence delimiter, CharSequence prefix, CharSequence suffix) {
    Objects.requireNonNull(prefix, "The prefix must not be null");
    Objects.requireNonNull(delimiter, "The delimiter must not be null");
    Objects.requireNonNull(suffix, "The suffix must not be null");
    this.prefix = prefix.toString();
    this.delimiter = delimiter.toString();
    this.suffix = suffix.toString();
    checkAddLength(0, 0);
  }

  // summary=p;Joiner;false;setEmptyValue;(CharSequence);;Argument[0];Argument[this];taint;df-generated
  // summary=p;Joiner;false;setEmptyValue;(CharSequence);;Argument[this];ReturnValue;value;df-generated
  // No content based summary as emptyValue is "dead" (synthetic)field.
  // contentbased-summary=p;Joiner;false;setEmptyValue;(CharSequence);;Argument[this];ReturnValue;value;dfc-generated
  public Joiner setEmptyValue(CharSequence emptyValue) {
    this.emptyValue =
        Objects.requireNonNull(emptyValue, "The empty value must not be null").toString();
    return this;
  }

  // summary=p;Joiner;false;getDelimiter;();;Argument[this];ReturnValue;taint;df-generated
  // contentbased-summary=p;Joiner;false;getDelimiter;();;Argument[this].SyntheticField[p.Joiner.delimiter];ReturnValue;value;dfc-generated
  public String getDelimiter() {
    return delimiter;
  }

  private static int getChars(String s, char[] chars, int start) {
    int len = s.length();
    s.getChars(0, len, chars, start);
    return len;
  }

  @Override
  public String toString() {
    final String[] elts = this.elts;
    if (elts == null && emptyValue != null) {
      return emptyValue;
    }
    final int size = this.size;
    final int addLen = prefix.length() + suffix.length();
    if (addLen == 0) {
      compactElts();
      return size == 0 ? "" : elts[0];
    }
    final String delimiter = this.delimiter;
    final char[] chars = new char[len + addLen];
    int k = getChars(prefix, chars, 0);
    if (size > 0) {
      k += getChars(elts[0], chars, k);
      for (int i = 1; i < size; i++) {
        k += getChars(delimiter, chars, k);
        k += getChars(elts[i], chars, k);
      }
    }
    k += getChars(suffix, chars, k);
    return new String(chars);
  }

  // summary=p;Joiner;false;add;(CharSequence);;Argument[this];ReturnValue;value;df-generated
  // contentbased-summary=p;Joiner;false;add;(CharSequence);;Argument[this];ReturnValue;value;dfc-generated
  // MISSING content based summaries for "elts". This could be a synthetic field.
  public Joiner add(CharSequence newElement) {
    final String elt = String.valueOf(newElement);
    if (elts == null) {
      elts = new String[8];
    } else {
      if (size == elts.length) elts = Arrays.copyOf(elts, 2 * size);
      len = checkAddLength(len, delimiter.length());
    }
    len = checkAddLength(len, elt.length());
    elts[size++] = elt;
    return this;
  }

  private int checkAddLength(int oldLen, int inc) {
    long newLen = (long) oldLen + (long) inc;
    long tmpLen = newLen + (long) prefix.length() + (long) suffix.length();
    if (tmpLen != (int) tmpLen) {
      throw new OutOfMemoryError("Requested array size exceeds VM limit");
    }
    return (int) newLen;
  }

  // summary=p;Joiner;false;merge;(Joiner);;Argument[this];ReturnValue;value;df-generated
  // contentbased-summary=p;Joiner;false;merge;(Joiner);;Argument[this];ReturnValue;value;dfc-generated
  // MISSING content based summaries for "elts". This could be a synthetic field.
  public Joiner merge(Joiner other) {
    Objects.requireNonNull(other);
    if (other.elts == null) {
      return this;
    }
    other.compactElts();
    return add(other.elts[0]);
  }

  private void compactElts() {
    if (size > 1) {
      final char[] chars = new char[len];
      int i = 1, k = getChars(elts[0], chars, 0);
      do {
        k += getChars(delimiter, chars, k);
        k += getChars(elts[i], chars, k);
        elts[i] = null;
      } while (++i < size);
      size = 1;
      elts[0] = new String(chars);
    }
  }

  // neutral=p;Joiner;length;();summary;df-generated
  public int length() {
    return (size == 0 && emptyValue != null)
        ? emptyValue.length()
        : len + prefix.length() + suffix.length();
  }
}
