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
        sink(StringUtils.abbreviate(taint(), 0)); // $hasTaintFlow=y
        sink(StringUtils.abbreviate(taint(), 0, 0)); // $hasTaintFlow=y
        sink(StringUtils.abbreviate(taint(), "...", 0)); // $hasTaintFlow=y
        sink(StringUtils.abbreviate("Untainted", taint(), 0)); // $hasTaintFlow=y
        sink(StringUtils.abbreviate(taint(), "...", 0, 0)); // $hasTaintFlow=y
        sink(StringUtils.abbreviate("Untainted", taint(), 0, 0)); // $hasTaintFlow=y
        sink(StringUtils.abbreviateMiddle(taint(), "...", 0)); // $hasTaintFlow=y
        sink(StringUtils.abbreviateMiddle("Untainted", taint(), 0)); // $hasTaintFlow=y
        sink(StringUtils.appendIfMissing(taint(), "suffix", "candsuffix1", "candsuffix2")); // $hasTaintFlow=y
        sink(StringUtils.appendIfMissing("prefix", taint(), "candsuffix1", "candsuffix2")); // $hasTaintFlow=y
        // (next 2 calls) GOOD: candidate suffixes do not flow to the return value.
        sink(StringUtils.appendIfMissing("prefix", "suffix", taint(), "candsuffix2"));
        sink(StringUtils.appendIfMissing("prefix", "suffix", "candsuffix1", taint()));
        sink(StringUtils.appendIfMissingIgnoreCase(taint(), "suffix", "candsuffix1", "candsuffix2")); // $hasTaintFlow=y
        sink(StringUtils.appendIfMissingIgnoreCase("prefix", taint(), "candsuffix1", "candsuffix2")); // $hasTaintFlow=y
        // (next 2 calls) GOOD: candidate suffixes do not flow to the return value.
        sink(StringUtils.appendIfMissingIgnoreCase("prefix", "suffix", taint(), "candsuffix2"));
        sink(StringUtils.appendIfMissingIgnoreCase("prefix", "suffix", "candsuffix1", taint()));
        sink(StringUtils.capitalize(taint())); // $hasTaintFlow=y
        sink(StringUtils.center(taint(), 0)); // $hasTaintFlow=y
        sink(StringUtils.center(taint(), 0, 'x')); // $hasTaintFlow=y
        sink(StringUtils.center(taint(), 0, "padding string")); // $hasTaintFlow=y
        sink(StringUtils.center("Center me", 0, taint())); // $hasTaintFlow=y
        sink(StringUtils.chomp(taint())); // $hasTaintFlow=y
        sink(StringUtils.chomp(taint(), "separator")); // $hasTaintFlow=y
        // GOOD: separator does not flow to the return value.
        sink(StringUtils.chomp("Chomp me", taint()));
        sink(StringUtils.chop(taint())); // $hasTaintFlow=y
        sink(StringUtils.defaultIfBlank(taint(), "default")); // $hasTaintFlow=y
        sink(StringUtils.defaultIfBlank("Perhaps blank", taint())); // $hasTaintFlow=y
        sink(StringUtils.defaultIfEmpty(taint(), "default")); // $hasTaintFlow=y
        sink(StringUtils.defaultIfEmpty("Perhaps empty", taint())); // $hasTaintFlow=y
        sink(StringUtils.defaultString(taint())); // $hasTaintFlow=y
        sink(StringUtils.defaultString(taint(), "default string")); // $hasTaintFlow=y
        sink(StringUtils.defaultString("perhaps null", taint())); // $hasTaintFlow=y
        sink(StringUtils.deleteWhitespace(taint())); // $hasTaintFlow=y
        sink(StringUtils.difference(taint(), "rhs")); // $hasTaintFlow=y
        sink(StringUtils.difference("lhs", taint())); // $hasTaintFlow=y
        sink(StringUtils.firstNonBlank(taint(), "second string")); // $hasTaintFlow=y
        sink(StringUtils.firstNonBlank("first string", taint())); // $hasTaintFlow=y
        sink(StringUtils.firstNonEmpty(taint(), "second string")); // $hasTaintFlow=y
        sink(StringUtils.firstNonEmpty("first string", taint())); // $hasTaintFlow=y
        sink(StringUtils.getBytes(taint(), (Charset)null)); // $hasTaintFlow=y
        sink(StringUtils.getBytes(taint(), "some charset")); // $hasTaintFlow=y
        // GOOD: charset names are not a source of taint
        sink(StringUtils.getBytes("some string", taint()));
        sink(StringUtils.getCommonPrefix(taint(), "second string")); // $hasTaintFlow=y
        sink(StringUtils.getCommonPrefix("first string", taint())); // $hasTaintFlow=y
        sink(StringUtils.getDigits(taint())); // $hasTaintFlow=y
        sink(StringUtils.getIfBlank(taint(), () -> "default")); // $hasTaintFlow=y
        sink(StringUtils.getIfEmpty(taint(), () -> "default")); // $hasTaintFlow=y
        // BAD (but not detected yet): latent taint in lambdas
        sink(StringUtils.getIfBlank("maybe blank", () -> taint()));
        sink(StringUtils.getIfEmpty("maybe blank", () -> taint()));
        // GOOD: byte arrays render as numbers, so can't usefully convey most forms
        // of tainted data.
        sink(StringUtils.join(StringUtils.getBytes(taint(), "UTF-8"), ' '));
        sink(StringUtils.join(StringUtils.getBytes(taint(), "UTF-8"), ' ', 0, 0));
        sink(StringUtils.join(taint().toCharArray(), ' ')); // $hasTaintFlow=y
        sink(StringUtils.join(taint().toCharArray(), ' ', 0, 0)); // $hasTaintFlow=y
        // Testing the Iterable<?> overloads of `join`
        List<String> taintedList = new ArrayList<>();
        taintedList.add(taint());
        sink(StringUtils.join(taintedList, ' ')); // $hasTaintFlow=y
        sink(StringUtils.join(taintedList, "sep")); // $hasTaintFlow=y
        List<String> untaintedList = new ArrayList<>();
        sink(StringUtils.join(untaintedList, taint())); // $hasTaintFlow=y
        // Testing the Iterator<?> overloads of `join`
        sink(StringUtils.join(taintedList.iterator(), ' ')); // $hasTaintFlow=y
        sink(StringUtils.join(taintedList.iterator(), "sep")); // $hasTaintFlow=y
        sink(StringUtils.join(untaintedList.iterator(), taint())); // $hasTaintFlow=y
        // Testing the List<?> overloads of `join`, which have start/end indices
        sink(StringUtils.join(taintedList, ' ', 0, 0)); // $hasTaintFlow=y
        sink(StringUtils.join(taintedList, "sep", 0, 0)); // $hasTaintFlow=y
        sink(StringUtils.join(untaintedList, taint(), 0, 0)); // $hasTaintFlow=y
        // Testing the Object[] overloads of `join`, which may have start/end indices
        Object[] taintedArray = new Object[] { taint() };
        sink(StringUtils.join(taintedArray, ' ')); // $hasTaintFlow=y
        sink(StringUtils.join(taintedArray, "sep")); // $hasTaintFlow=y
        sink(StringUtils.join(taintedArray, ' ', 0, 0)); // $hasTaintFlow=y
        sink(StringUtils.join(taintedArray, "sep", 0, 0)); // $hasTaintFlow=y
        Object[] untaintedArray = new Object[] { "safe" };
        sink(StringUtils.join(untaintedArray, taint())); // $hasTaintFlow=y
        sink(StringUtils.join(untaintedArray, taint(), 0, 0)); // $hasTaintFlow=y
        // Testing the variadic overload of `join` and `joinWith`
        sink(StringUtils.join(taint(), "other string")); // $hasTaintFlow=y
        sink(StringUtils.join("other string before", taint())); // $hasTaintFlow=y
        sink(StringUtils.joinWith("separator", taint(), "other string")); // $hasTaintFlow=y
        sink(StringUtils.joinWith("separator", "other string before", taint())); // $hasTaintFlow=y
        sink(StringUtils.joinWith(taint(), "other string before", "other string after")); // $hasTaintFlow=y
        // End of `join` tests
        sink(StringUtils.left(taint(), 0)); // $hasTaintFlow=y
        sink(StringUtils.leftPad(taint(), 0)); // $hasTaintFlow=y
        sink(StringUtils.leftPad(taint(), 0, ' ')); // $hasTaintFlow=y
        sink(StringUtils.leftPad(taint(), 0, "padding")); // $hasTaintFlow=y
        sink(StringUtils.leftPad("to pad", 0, taint())); // $hasTaintFlow=y
        sink(StringUtils.lowerCase(taint())); // $hasTaintFlow=y
        sink(StringUtils.lowerCase(taint(), Locale.UK)); // $hasTaintFlow=y
        sink(StringUtils.mid(taint(), 0, 0)); // $hasTaintFlow=y
        sink(StringUtils.normalizeSpace(taint())); // $hasTaintFlow=y
        sink(StringUtils.overlay(taint(), "overlay", 0, 0)); // $hasTaintFlow=y
        sink(StringUtils.overlay("underlay", taint(), 0, 0)); // $hasTaintFlow=y
        sink(StringUtils.prependIfMissing(taint(), "append prefix", "check prefix 1", "check prefix 2")); // $hasTaintFlow=y
        sink(StringUtils.prependIfMissing("original string", taint(), "check prefix 1", "check prefix 2")); // $hasTaintFlow=y
        // (next 2 calls) GOOD: args 3+ are checked against but do not propagate to the return value
        sink(StringUtils.prependIfMissing("original string", "append prefix", taint(), "check prefix 2"));
        sink(StringUtils.prependIfMissing("original string", "append prefix", "check prefix 1", taint()));
        sink(StringUtils.prependIfMissingIgnoreCase(taint(), "append prefix", "check prefix 1", "check prefix 2")); // $hasTaintFlow=y
        sink(StringUtils.prependIfMissingIgnoreCase("original string", taint(), "check prefix 1", "check prefix 2")); // $hasTaintFlow=y
        // (next 2 calls) GOOD: args 3+ are checked against but do not propagate to the return value
        sink(StringUtils.prependIfMissingIgnoreCase("original string", "append prefix", taint(), "check prefix 2"));
        sink(StringUtils.prependIfMissingIgnoreCase("original string", "append prefix", "check prefix 1", taint()));
        sink(StringUtils.remove(taint(), ' ')); // $hasTaintFlow=y
        sink(StringUtils.remove(taint(), "delete me")); // $hasTaintFlow=y
        sink(StringUtils.removeAll(taint(), "delete me")); // $hasTaintFlow=y
        sink(StringUtils.removeEnd(taint(), "delete me")); // $hasTaintFlow=y
        sink(StringUtils.removeEndIgnoreCase(taint(), "delete me")); // $hasTaintFlow=y
        sink(StringUtils.removeFirst(taint(), "delete me")); // $hasTaintFlow=y
        sink(StringUtils.removeIgnoreCase(taint(), "delete me")); // $hasTaintFlow=y
        sink(StringUtils.removePattern(taint(), "delete me")); // $hasTaintFlow=y
        sink(StringUtils.removeStart(taint(), "delete me")); // $hasTaintFlow=y
        sink(StringUtils.removeStartIgnoreCase(taint(), "delete me")); // $hasTaintFlow=y
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
        sink(StringUtils.repeat(taint(), 1)); // $hasTaintFlow=y
        sink(StringUtils.repeat(taint(), "separator", 1)); // $hasTaintFlow=y
        sink(StringUtils.repeat("repeat me", taint(), 1)); // $hasTaintFlow=y
        sink(StringUtils.replace(taint(), "search", "replacement")); // $hasTaintFlow=y
        sink(StringUtils.replace("haystack", "search", taint())); // $hasTaintFlow=y
        sink(StringUtils.replace(taint(), "search", "replacement", 0)); // $hasTaintFlow=y
        sink(StringUtils.replace("haystack", "search", taint(), 0)); // $hasTaintFlow=y
        sink(StringUtils.replaceAll(taint(), "search", "replacement")); // $hasTaintFlow=y
        sink(StringUtils.replaceAll("haystack", "search", taint())); // $hasTaintFlow=y
        sink(StringUtils.replaceChars(taint(), 'a', 'b')); // $hasTaintFlow=y
        sink(StringUtils.replaceChars(taint(), "abc", "xyz")); // $hasTaintFlow=y
        sink(StringUtils.replaceChars("haystack", "abc", taint())); // $hasTaintFlow=y
        sink(StringUtils.replaceEach(taint(), new String[] { "search" }, new String[] { "replacement" })); // $hasTaintFlow=y
        sink(StringUtils.replaceEach("haystack", new String[] { "search" }, new String[] { taint() })); // $hasTaintFlow=y
        sink(StringUtils.replaceEachRepeatedly(taint(), new String[] { "search" }, new String[] { "replacement" })); // $hasTaintFlow=y
        sink(StringUtils.replaceEachRepeatedly("haystack", new String[] { "search" }, new String[] { taint() })); // $hasTaintFlow=y
        sink(StringUtils.replaceFirst(taint(), "search", "replacement")); // $hasTaintFlow=y
        sink(StringUtils.replaceFirst("haystack", "search", taint())); // $hasTaintFlow=y
        sink(StringUtils.replaceIgnoreCase(taint(), "search", "replacement")); // $hasTaintFlow=y
        sink(StringUtils.replaceIgnoreCase("haystack", "search", taint())); // $hasTaintFlow=y
        sink(StringUtils.replaceOnce(taint(), "search", "replacement")); // $hasTaintFlow=y
        sink(StringUtils.replaceOnce("haystack", "search", taint())); // $hasTaintFlow=y
        sink(StringUtils.replaceOnceIgnoreCase(taint(), "search", "replacement")); // $hasTaintFlow=y
        sink(StringUtils.replaceOnceIgnoreCase("haystack", "search", taint())); // $hasTaintFlow=y
        sink(StringUtils.replacePattern(taint(), "search", "replacement")); // $hasTaintFlow=y
        sink(StringUtils.replacePattern("haystack", "search", taint())); // $hasTaintFlow=y
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
        sink(StringUtils.reverse(taint())); // $hasTaintFlow=y
        sink(StringUtils.reverseDelimited(taint(), ',')); // $hasTaintFlow=y
        sink(StringUtils.right(taint(), 0)); // $hasTaintFlow=y
        sink(StringUtils.rightPad(taint(), 0)); // $hasTaintFlow=y
        sink(StringUtils.rightPad(taint(), 0, ' ')); // $hasTaintFlow=y
        sink(StringUtils.rightPad(taint(), 0, "padding")); // $hasTaintFlow=y
        sink(StringUtils.rightPad("to pad", 0, taint())); // $hasTaintFlow=y
        sink(StringUtils.rotate(taint(), 0)); // $hasTaintFlow=y
        sink(StringUtils.split(taint())); // $hasTaintFlow=y
        sink(StringUtils.split(taint(), ' ')); // $hasTaintFlow=y
        sink(StringUtils.split(taint(), " ,; // $hasTaintFlow=y")); // $hasTaintFlow=y
        sink(StringUtils.split(taint(), " ,; // $hasTaintFlow=y", 0)); // $hasTaintFlow=y
        sink(StringUtils.splitByCharacterType(taint())); // $hasTaintFlow=y
        sink(StringUtils.splitByCharacterTypeCamelCase(taint())); // $hasTaintFlow=y
        sink(StringUtils.splitByWholeSeparator(taint(), "separator")); // $hasTaintFlow=y
        sink(StringUtils.splitByWholeSeparator(taint(), "separator", 0)); // $hasTaintFlow=y
        sink(StringUtils.splitByWholeSeparatorPreserveAllTokens(taint(), "separator")); // $hasTaintFlow=y
        sink(StringUtils.splitByWholeSeparatorPreserveAllTokens(taint(), "separator", 0)); // $hasTaintFlow=y
        sink(StringUtils.splitPreserveAllTokens(taint())); // $hasTaintFlow=y
        sink(StringUtils.splitPreserveAllTokens(taint(), ' ')); // $hasTaintFlow=y
        sink(StringUtils.splitPreserveAllTokens(taint(), " ,;")); // $hasTaintFlow=y
        sink(StringUtils.splitPreserveAllTokens(taint(), " ,;", 0)); // $hasTaintFlow=y
        // GOOD (next 8 calls): separators don't propagate to the return value
        sink(StringUtils.split("to split", taint()));
        sink(StringUtils.split("to split", taint(), 0));
        sink(StringUtils.splitPreserveAllTokens("to split", taint(), 0));
        sink(StringUtils.splitByWholeSeparator("to split", taint()));
        sink(StringUtils.splitByWholeSeparator("to split", taint(), 0));
        sink(StringUtils.splitByWholeSeparatorPreserveAllTokens("to split", taint()));
        sink(StringUtils.splitByWholeSeparatorPreserveAllTokens("to split", taint(), 0));
        sink(StringUtils.splitPreserveAllTokens("to split", taint()));
        sink(StringUtils.strip(taint())); // $hasTaintFlow=y
        sink(StringUtils.strip(taint(), "charstoremove")); // $hasTaintFlow=y
        sink(StringUtils.stripAccents(taint())); // $hasTaintFlow=y
        sink(StringUtils.stripAll(new String[] { taint() }, "charstoremove")); // $hasTaintFlow=y
        sink(StringUtils.stripEnd(taint(), "charstoremove")); // $hasTaintFlow=y
        sink(StringUtils.stripStart(taint(), "charstoremove")); // $hasTaintFlow=y
        // GOOD (next 4 calls): stripped chars do not flow to the return value.
        sink(StringUtils.strip("original text", taint()));
        sink(StringUtils.stripAll(new String[] { "original text" }, taint()));
        sink(StringUtils.stripEnd("original text", taint()));
        sink(StringUtils.stripStart("original text", taint()));
        sink(StringUtils.stripToEmpty(taint())); // $hasTaintFlow=y
        sink(StringUtils.stripToNull(taint())); // $hasTaintFlow=y
        sink(StringUtils.substring(taint(), 0)); // $hasTaintFlow=y
        sink(StringUtils.substring(taint(), 0, 0)); // $hasTaintFlow=y
        sink(StringUtils.substringAfter(taint(), 0)); // $hasTaintFlow=y
        sink(StringUtils.substringAfter(taint(), "separator")); // $hasTaintFlow=y
        sink(StringUtils.substringAfterLast(taint(), 0)); // $hasTaintFlow=y
        sink(StringUtils.substringAfterLast(taint(), "separator")); // $hasTaintFlow=y
        sink(StringUtils.substringBefore(taint(), "separator")); // $hasTaintFlow=y
        sink(StringUtils.substringBeforeLast(taint(), "separator")); // $hasTaintFlow=y
        sink(StringUtils.substringBetween(taint(), "separator")); // $hasTaintFlow=y
        sink(StringUtils.substringBetween(taint(), "start-tag", "end-tag")); // $hasTaintFlow=y
        sink(StringUtils.substringsBetween(taint(), "start-tag", "end-tag")[0]); // $hasTaintFlow=y
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
        sink(StringUtils.swapCase(taint())); // $hasTaintFlow=y
        sink(StringUtils.toCodePoints(taint())); // $hasTaintFlow=y
        sink(StringUtils.toEncodedString(StringUtils.getBytes(taint(), "charset"), null)); // $hasTaintFlow=y
        sink(StringUtils.toRootLowerCase(taint())); // $hasTaintFlow=y
        sink(StringUtils.toRootUpperCase(taint())); // $hasTaintFlow=y
        sink(StringUtils.toString(StringUtils.getBytes(taint(), "charset"), "charset")); // $hasTaintFlow=y
        sink(StringUtils.trim(taint())); // $hasTaintFlow=y
        sink(StringUtils.trimToEmpty(taint())); // $hasTaintFlow=y
        sink(StringUtils.trimToNull(taint())); // $hasTaintFlow=y
        sink(StringUtils.truncate(taint(), 0)); // $hasTaintFlow=y
        sink(StringUtils.truncate(taint(), 0, 0)); // $hasTaintFlow=y
        sink(StringUtils.uncapitalize(taint())); // $hasTaintFlow=y
        sink(StringUtils.unwrap(taint(), '"')); // $hasTaintFlow=y
        sink(StringUtils.unwrap(taint(), "separator")); // $hasTaintFlow=y
        // GOOD: the wrapper string does not flow to the return value.
        sink(StringUtils.unwrap("original string", taint()));
        sink(StringUtils.upperCase(taint())); // $hasTaintFlow=y
        sink(StringUtils.upperCase(taint(), null)); // $hasTaintFlow=y
        sink(StringUtils.valueOf(taint().toCharArray())); // $hasTaintFlow=y
        sink(StringUtils.wrap(taint(), '"')); // $hasTaintFlow=y
        sink(StringUtils.wrap(taint(), "wrapper token")); // $hasTaintFlow=y
        sink(StringUtils.wrap("wrap me", taint())); // $hasTaintFlow=y
        sink(StringUtils.wrapIfMissing(taint(), '"')); // $hasTaintFlow=y
        sink(StringUtils.wrapIfMissing(taint(), "wrapper token")); // $hasTaintFlow=y
        sink(StringUtils.wrapIfMissing("wrap me", taint())); // $hasTaintFlow=y

    }

}