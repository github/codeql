import org.apache.commons.lang3.StringUtils;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

class Test {
    String taint() { return "tainted"; }

    void sink(Object o) {}

    void test() throws Exception {

        // All these calls should convey taint to `sink` except as noted.
        sink(StringUtils.abbreviate(taint(), 0)); // $hasTaintFlow
        sink(StringUtils.abbreviate(taint(), 0, 0)); // $hasTaintFlow
        sink(StringUtils.abbreviate(taint(), "...", 0)); // $hasTaintFlow
        sink(StringUtils.abbreviate("Untainted", taint(), 0)); // $hasTaintFlow
        sink(StringUtils.abbreviate(taint(), "...", 0, 0)); // $hasTaintFlow
        sink(StringUtils.abbreviate("Untainted", taint(), 0, 0)); // $hasTaintFlow
        sink(StringUtils.abbreviateMiddle(taint(), "...", 0)); // $hasTaintFlow
        sink(StringUtils.abbreviateMiddle("Untainted", taint(), 0)); // $hasTaintFlow
        sink(StringUtils.appendIfMissing(taint(), "suffix", "candsuffix1", "candsuffix2")); // $hasTaintFlow
        sink(StringUtils.appendIfMissing("prefix", taint(), "candsuffix1", "candsuffix2")); // $hasTaintFlow
        // (next 2 calls) GOOD: candidate suffixes do not flow to the return value.
        sink(StringUtils.appendIfMissing("prefix", "suffix", taint(), "candsuffix2"));
        sink(StringUtils.appendIfMissing("prefix", "suffix", "candsuffix1", taint()));
        sink(StringUtils.appendIfMissingIgnoreCase(taint(), "suffix", "candsuffix1", "candsuffix2")); // $hasTaintFlow
        sink(StringUtils.appendIfMissingIgnoreCase("prefix", taint(), "candsuffix1", "candsuffix2")); // $hasTaintFlow
        // (next 2 calls) GOOD: candidate suffixes do not flow to the return value.
        sink(StringUtils.appendIfMissingIgnoreCase("prefix", "suffix", taint(), "candsuffix2"));
        sink(StringUtils.appendIfMissingIgnoreCase("prefix", "suffix", "candsuffix1", taint()));
        sink(StringUtils.capitalize(taint())); // $hasTaintFlow
        sink(StringUtils.center(taint(), 0)); // $hasTaintFlow
        sink(StringUtils.center(taint(), 0, 'x')); // $hasTaintFlow
        sink(StringUtils.center(taint(), 0, "padding string")); // $hasTaintFlow
        sink(StringUtils.center("Center me", 0, taint())); // $hasTaintFlow
        sink(StringUtils.chomp(taint())); // $hasTaintFlow
        sink(StringUtils.chomp(taint(), "separator")); // $hasTaintFlow
        // GOOD: separator does not flow to the return value.
        sink(StringUtils.chomp("Chomp me", taint()));
        sink(StringUtils.chop(taint())); // $hasTaintFlow
        sink(StringUtils.defaultIfBlank(taint(), "default")); // $hasTaintFlow
        sink(StringUtils.defaultIfBlank("Perhaps blank", taint())); // $hasTaintFlow
        sink(StringUtils.defaultIfEmpty(taint(), "default")); // $hasTaintFlow
        sink(StringUtils.defaultIfEmpty("Perhaps empty", taint())); // $hasTaintFlow
        sink(StringUtils.defaultString(taint())); // $hasTaintFlow
        sink(StringUtils.defaultString(taint(), "default string")); // $hasTaintFlow
        sink(StringUtils.defaultString("perhaps null", taint())); // $hasTaintFlow
        sink(StringUtils.deleteWhitespace(taint())); // $hasTaintFlow
        sink(StringUtils.difference(taint(), "rhs")); // $hasTaintFlow
        sink(StringUtils.difference("lhs", taint())); // $hasTaintFlow
        sink(StringUtils.firstNonBlank(taint(), "second string")); // $hasValueFlow
        sink(StringUtils.firstNonBlank("first string", taint())); // $hasValueFlow
        sink(StringUtils.firstNonEmpty(taint(), "second string")); // $hasValueFlow
        sink(StringUtils.firstNonEmpty("first string", taint())); // $hasValueFlow
        sink(StringUtils.getBytes(taint(), (Charset)null)); // $hasTaintFlow
        sink(StringUtils.getBytes(taint(), "some charset")); // $hasTaintFlow
        // GOOD: charset names are not a source of taint
        sink(StringUtils.getBytes("some string", taint()));
        sink(StringUtils.getCommonPrefix(taint(), "second string")); // $hasTaintFlow
        sink(StringUtils.getCommonPrefix("first string", taint())); // $hasTaintFlow
        sink(StringUtils.getDigits(taint())); // $hasTaintFlow
        sink(StringUtils.getIfBlank(taint(), () -> "default")); // $hasTaintFlow
        sink(StringUtils.getIfEmpty(taint(), () -> "default")); // $hasTaintFlow
        // BAD (but not detected yet): latent taint in lambdas
        sink(StringUtils.getIfBlank("maybe blank", () -> taint()));
        sink(StringUtils.getIfEmpty("maybe blank", () -> taint()));
        // GOOD: byte arrays render as numbers, so can't usefully convey most forms
        // of tainted data.
        sink(StringUtils.join(StringUtils.getBytes(taint(), "UTF-8"), ' '));
        sink(StringUtils.join(StringUtils.getBytes(taint(), "UTF-8"), ' ', 0, 0));
        sink(StringUtils.join(taint().toCharArray(), ' ')); // $hasTaintFlow
        sink(StringUtils.join(taint().toCharArray(), ' ', 0, 0)); // $hasTaintFlow
        // Testing the Iterable<?> overloads of `join`
        List<String> taintedList = new ArrayList<>();
        taintedList.add(taint());
        sink(StringUtils.join(taintedList, ' ')); // $hasTaintFlow
        sink(StringUtils.join(taintedList, "sep")); // $hasTaintFlow
        List<String> untaintedList = new ArrayList<>();
        sink(StringUtils.join(untaintedList, taint())); // $hasTaintFlow
        // Testing the Iterator<?> overloads of `join`
        sink(StringUtils.join(taintedList.iterator(), ' ')); // $hasTaintFlow
        sink(StringUtils.join(taintedList.iterator(), "sep")); // $hasTaintFlow
        sink(StringUtils.join(untaintedList.iterator(), taint())); // $hasTaintFlow
        // Testing the List<?> overloads of `join`, which have start/end indices
        sink(StringUtils.join(taintedList, ' ', 0, 0)); // $hasTaintFlow
        sink(StringUtils.join(taintedList, "sep", 0, 0)); // $hasTaintFlow
        sink(StringUtils.join(untaintedList, taint(), 0, 0)); // $hasTaintFlow
        // Testing the Object[] overloads of `join`, which may have start/end indices
        Object[] taintedArray = new Object[] { taint() };
        sink(StringUtils.join(taintedArray, ' ')); // $hasTaintFlow
        sink(StringUtils.join(taintedArray, "sep")); // $hasTaintFlow
        sink(StringUtils.join(taintedArray, ' ', 0, 0)); // $hasTaintFlow
        sink(StringUtils.join(taintedArray, "sep", 0, 0)); // $hasTaintFlow
        Object[] untaintedArray = new Object[] { "safe" };
        sink(StringUtils.join(untaintedArray, taint())); // $hasTaintFlow
        sink(StringUtils.join(untaintedArray, taint(), 0, 0)); // $hasTaintFlow
        // Testing the variadic overload of `join` and `joinWith`
        sink(StringUtils.join(taint(), "other string")); // $hasTaintFlow
        sink(StringUtils.join("other string before", taint())); // $hasTaintFlow
        sink(StringUtils.joinWith("separator", taint(), "other string")); // $hasTaintFlow
        sink(StringUtils.joinWith("separator", "other string before", taint())); // $hasTaintFlow
        sink(StringUtils.joinWith(taint(), "other string before", "other string after")); // $hasTaintFlow
        // End of `join` tests
        sink(StringUtils.left(taint(), 0)); // $hasTaintFlow
        sink(StringUtils.leftPad(taint(), 0)); // $hasTaintFlow
        sink(StringUtils.leftPad(taint(), 0, ' ')); // $hasTaintFlow
        sink(StringUtils.leftPad(taint(), 0, "padding")); // $hasTaintFlow
        sink(StringUtils.leftPad("to pad", 0, taint())); // $hasTaintFlow
        sink(StringUtils.lowerCase(taint())); // $hasTaintFlow
        sink(StringUtils.lowerCase(taint(), Locale.UK)); // $hasTaintFlow
        sink(StringUtils.mid(taint(), 0, 0)); // $hasTaintFlow
        sink(StringUtils.normalizeSpace(taint())); // $hasTaintFlow
        sink(StringUtils.overlay(taint(), "overlay", 0, 0)); // $hasTaintFlow
        sink(StringUtils.overlay("underlay", taint(), 0, 0)); // $hasTaintFlow
        sink(StringUtils.prependIfMissing(taint(), "append prefix", "check prefix 1", "check prefix 2")); // $hasTaintFlow
        sink(StringUtils.prependIfMissing("original string", taint(), "check prefix 1", "check prefix 2")); // $hasTaintFlow
        // (next 2 calls) GOOD: args 3+ are checked against but do not propagate to the return value
        sink(StringUtils.prependIfMissing("original string", "append prefix", taint(), "check prefix 2"));
        sink(StringUtils.prependIfMissing("original string", "append prefix", "check prefix 1", taint()));
        sink(StringUtils.prependIfMissingIgnoreCase(taint(), "append prefix", "check prefix 1", "check prefix 2")); // $hasTaintFlow
        sink(StringUtils.prependIfMissingIgnoreCase("original string", taint(), "check prefix 1", "check prefix 2")); // $hasTaintFlow
        // (next 2 calls) GOOD: args 3+ are checked against but do not propagate to the return value
        sink(StringUtils.prependIfMissingIgnoreCase("original string", "append prefix", taint(), "check prefix 2"));
        sink(StringUtils.prependIfMissingIgnoreCase("original string", "append prefix", "check prefix 1", taint()));
        sink(StringUtils.remove(taint(), ' ')); // $hasTaintFlow
        sink(StringUtils.remove(taint(), "delete me")); // $hasTaintFlow
        sink(StringUtils.removeAll(taint(), "delete me")); // $hasTaintFlow
        sink(StringUtils.removeEnd(taint(), "delete me")); // $hasTaintFlow
        sink(StringUtils.removeEndIgnoreCase(taint(), "delete me")); // $hasTaintFlow
        sink(StringUtils.removeFirst(taint(), "delete me")); // $hasTaintFlow
        sink(StringUtils.removeIgnoreCase(taint(), "delete me")); // $hasTaintFlow
        sink(StringUtils.removePattern(taint(), "delete me")); // $hasTaintFlow
        sink(StringUtils.removeStart(taint(), "delete me")); // $hasTaintFlow
        sink(StringUtils.removeStartIgnoreCase(taint(), "delete me")); // $hasTaintFlow
        // GOOD (next 9 calls): the removed string doesn't propagate to the return value
        sink(StringUtils.remove("remove from", taint()));
        sink(StringUtils.removeAll("remove from", taint()));
        sink(StringUtils.removeEnd("remove from", taint()));
        sink(StringUtils.removeEndIgnoreCase("remove from", taint()));
        sink(StringUtils.removeFirst("remove from", taint()));
        sink(StringUtils.removeIgnoreCase("remove from", taint()));
        sink(StringUtils.removePattern("remove from", taint()));
        sink(StringUtils.removeStart("remove from", taint()));
        sink(StringUtils.removeStartIgnoreCase("remove from", taint()));
        sink(StringUtils.repeat(taint(), 1)); // $hasTaintFlow
        sink(StringUtils.repeat(taint(), "separator", 1)); // $hasTaintFlow
        sink(StringUtils.repeat("repeat me", taint(), 1)); // $hasTaintFlow
        sink(StringUtils.replace(taint(), "search", "replacement")); // $hasTaintFlow
        sink(StringUtils.replace("haystack", "search", taint())); // $hasTaintFlow
        sink(StringUtils.replace(taint(), "search", "replacement", 0)); // $hasTaintFlow
        sink(StringUtils.replace("haystack", "search", taint(), 0)); // $hasTaintFlow
        sink(StringUtils.replaceAll(taint(), "search", "replacement")); // $hasTaintFlow
        sink(StringUtils.replaceAll("haystack", "search", taint())); // $hasTaintFlow
        sink(StringUtils.replaceChars(taint(), 'a', 'b')); // $hasTaintFlow
        sink(StringUtils.replaceChars(taint(), "abc", "xyz")); // $hasTaintFlow
        sink(StringUtils.replaceChars("haystack", "abc", taint())); // $hasTaintFlow
        sink(StringUtils.replaceEach(taint(), new String[] { "search" }, new String[] { "replacement" })); // $hasTaintFlow
        sink(StringUtils.replaceEach("haystack", new String[] { "search" }, new String[] { taint() })); // $hasTaintFlow
        sink(StringUtils.replaceEachRepeatedly(taint(), new String[] { "search" }, new String[] { "replacement" })); // $hasTaintFlow
        sink(StringUtils.replaceEachRepeatedly("haystack", new String[] { "search" }, new String[] { taint() })); // $hasTaintFlow
        sink(StringUtils.replaceFirst(taint(), "search", "replacement")); // $hasTaintFlow
        sink(StringUtils.replaceFirst("haystack", "search", taint())); // $hasTaintFlow
        sink(StringUtils.replaceIgnoreCase(taint(), "search", "replacement")); // $hasTaintFlow
        sink(StringUtils.replaceIgnoreCase("haystack", "search", taint())); // $hasTaintFlow
        sink(StringUtils.replaceOnce(taint(), "search", "replacement")); // $hasTaintFlow
        sink(StringUtils.replaceOnce("haystack", "search", taint())); // $hasTaintFlow
        sink(StringUtils.replaceOnceIgnoreCase(taint(), "search", "replacement")); // $hasTaintFlow
        sink(StringUtils.replaceOnceIgnoreCase("haystack", "search", taint())); // $hasTaintFlow
        sink(StringUtils.replacePattern(taint(), "search", "replacement")); // $hasTaintFlow
        sink(StringUtils.replacePattern("haystack", "search", taint())); // $hasTaintFlow
        // GOOD (next 11 calls): searched string in replace methods does not flow to the return value.
        sink(StringUtils.replace("haystack", taint(), "replacement"));
        sink(StringUtils.replace("haystack", taint(), "replacement", 0));
        sink(StringUtils.replaceAll("haystack", taint(), "replacement"));
        sink(StringUtils.replaceChars("haystack", taint(), "xyz"));
        sink(StringUtils.replaceEach("haystack", new String[] { taint() }, new String[] { "replacement" }));
        sink(StringUtils.replaceEachRepeatedly("haystack", new String[] { taint() }, new String[] { "replacement" }));
        sink(StringUtils.replaceFirst("haystack", taint(), "replacement"));
        sink(StringUtils.replaceIgnoreCase("haystack", taint(), "replacement"));
        sink(StringUtils.replaceOnce("haystack", taint(), "replacement"));
        sink(StringUtils.replaceOnceIgnoreCase("haystack", taint(), "replacement"));
        sink(StringUtils.replacePattern("haystack", taint(), "replacement"));
        sink(StringUtils.reverse(taint())); // $hasTaintFlow
        sink(StringUtils.reverseDelimited(taint(), ',')); // $hasTaintFlow
        sink(StringUtils.right(taint(), 0)); // $hasTaintFlow
        sink(StringUtils.rightPad(taint(), 0)); // $hasTaintFlow
        sink(StringUtils.rightPad(taint(), 0, ' ')); // $hasTaintFlow
        sink(StringUtils.rightPad(taint(), 0, "padding")); // $hasTaintFlow
        sink(StringUtils.rightPad("to pad", 0, taint())); // $hasTaintFlow
        sink(StringUtils.rotate(taint(), 0)); // $hasTaintFlow
        sink(StringUtils.split(taint())); // $hasTaintFlow
        sink(StringUtils.split(taint(), ' ')); // $hasTaintFlow
        sink(StringUtils.split(taint(), " ,;")); // $hasTaintFlow
        sink(StringUtils.split(taint(), " ,;", 0)); // $hasTaintFlow
        sink(StringUtils.splitByCharacterType(taint())); // $hasTaintFlow
        sink(StringUtils.splitByCharacterTypeCamelCase(taint())); // $hasTaintFlow
        sink(StringUtils.splitByWholeSeparator(taint(), "separator")); // $hasTaintFlow
        sink(StringUtils.splitByWholeSeparator(taint(), "separator", 0)); // $hasTaintFlow
        sink(StringUtils.splitByWholeSeparatorPreserveAllTokens(taint(), "separator")); // $hasTaintFlow
        sink(StringUtils.splitByWholeSeparatorPreserveAllTokens(taint(), "separator", 0)); // $hasTaintFlow
        sink(StringUtils.splitPreserveAllTokens(taint())); // $hasTaintFlow
        sink(StringUtils.splitPreserveAllTokens(taint(), ' ')); // $hasTaintFlow
        sink(StringUtils.splitPreserveAllTokens(taint(), " ,;")); // $hasTaintFlow
        sink(StringUtils.splitPreserveAllTokens(taint(), " ,;", 0)); // $hasTaintFlow
        // GOOD (next 8 calls): separators don't propagate to the return value
        sink(StringUtils.split("to split", taint()));
        sink(StringUtils.split("to split", taint(), 0));
        sink(StringUtils.splitPreserveAllTokens("to split", taint(), 0));
        sink(StringUtils.splitByWholeSeparator("to split", taint()));
        sink(StringUtils.splitByWholeSeparator("to split", taint(), 0));
        sink(StringUtils.splitByWholeSeparatorPreserveAllTokens("to split", taint()));
        sink(StringUtils.splitByWholeSeparatorPreserveAllTokens("to split", taint(), 0));
        sink(StringUtils.splitPreserveAllTokens("to split", taint()));
        sink(StringUtils.strip(taint())); // $hasTaintFlow
        sink(StringUtils.strip(taint(), "charstoremove")); // $hasTaintFlow
        sink(StringUtils.stripAccents(taint())); // $hasTaintFlow
        sink(StringUtils.stripAll(new String[] { taint() }, "charstoremove")[0]); // $hasTaintFlow
        sink(StringUtils.stripEnd(taint(), "charstoremove")); // $hasTaintFlow
        sink(StringUtils.stripStart(taint(), "charstoremove")); // $hasTaintFlow
        // GOOD (next 4 calls): stripped chars do not flow to the return value.
        sink(StringUtils.strip("original text", taint()));
        sink(StringUtils.stripAll(new String[] { "original text" }, taint())[0]);
        sink(StringUtils.stripEnd("original text", taint()));
        sink(StringUtils.stripStart("original text", taint()));
        sink(StringUtils.stripToEmpty(taint())); // $hasTaintFlow
        sink(StringUtils.stripToNull(taint())); // $hasTaintFlow
        sink(StringUtils.substring(taint(), 0)); // $hasTaintFlow
        sink(StringUtils.substring(taint(), 0, 0)); // $hasTaintFlow
        sink(StringUtils.substringAfter(taint(), 0)); // $hasTaintFlow
        sink(StringUtils.substringAfter(taint(), "separator")); // $hasTaintFlow
        sink(StringUtils.substringAfterLast(taint(), 0)); // $hasTaintFlow
        sink(StringUtils.substringAfterLast(taint(), "separator")); // $hasTaintFlow
        sink(StringUtils.substringBefore(taint(), "separator")); // $hasTaintFlow
        sink(StringUtils.substringBeforeLast(taint(), "separator")); // $hasTaintFlow
        sink(StringUtils.substringBetween(taint(), "separator")); // $hasTaintFlow
        sink(StringUtils.substringBetween(taint(), "start-tag", "end-tag")); // $hasTaintFlow
        sink(StringUtils.substringsBetween(taint(), "start-tag", "end-tag")[0]); // $hasTaintFlow
        // GOOD (next 9 calls): separators and bounding tags do not flow to the return value.
        sink(StringUtils.substringAfter("original text", taint()));
        sink(StringUtils.substringAfterLast("original text", taint()));
        sink(StringUtils.substringBefore("original text", taint()));
        sink(StringUtils.substringBeforeLast("original text", taint()));
        sink(StringUtils.substringBetween("original text", taint()));
        sink(StringUtils.substringBetween("original text", taint(), "end-tag"));
        sink(StringUtils.substringBetween("original text", "start-tag", taint()));
        sink(StringUtils.substringsBetween("original text", taint(), "end-tag")[0]);
        sink(StringUtils.substringsBetween("original text", "start-tag", taint())[0]);
        sink(StringUtils.swapCase(taint())); // $hasTaintFlow
        sink(StringUtils.toCodePoints(taint())); // $hasTaintFlow
        sink(StringUtils.toEncodedString(StringUtils.getBytes(taint(), "charset"), null)); // $hasTaintFlow
        sink(StringUtils.toRootLowerCase(taint())); // $hasTaintFlow
        sink(StringUtils.toRootUpperCase(taint())); // $hasTaintFlow
        sink(StringUtils.toString(StringUtils.getBytes(taint(), "charset"), "charset")); // $hasTaintFlow
        sink(StringUtils.trim(taint())); // $hasTaintFlow
        sink(StringUtils.trimToEmpty(taint())); // $hasTaintFlow
        sink(StringUtils.trimToNull(taint())); // $hasTaintFlow
        sink(StringUtils.truncate(taint(), 0)); // $hasTaintFlow
        sink(StringUtils.truncate(taint(), 0, 0)); // $hasTaintFlow
        sink(StringUtils.uncapitalize(taint())); // $hasTaintFlow
        sink(StringUtils.unwrap(taint(), '"')); // $hasTaintFlow
        sink(StringUtils.unwrap(taint(), "separator")); // $hasTaintFlow
        // GOOD: the wrapper string does not flow to the return value.
        sink(StringUtils.unwrap("original string", taint()));
        sink(StringUtils.upperCase(taint())); // $hasTaintFlow
        sink(StringUtils.upperCase(taint(), null)); // $hasTaintFlow
        sink(StringUtils.valueOf(taint().toCharArray())); // $hasTaintFlow
        sink(StringUtils.wrap(taint(), '"')); // $hasTaintFlow
        sink(StringUtils.wrap(taint(), "wrapper token")); // $hasTaintFlow
        sink(StringUtils.wrap("wrap me", taint())); // $hasTaintFlow
        sink(StringUtils.wrapIfMissing(taint(), '"')); // $hasTaintFlow
        sink(StringUtils.wrapIfMissing(taint(), "wrapper token")); // $hasTaintFlow
        sink(StringUtils.wrapIfMissing("wrap me", taint())); // $hasTaintFlow

    }

}
