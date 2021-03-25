import org.springframework.util.StringUtils;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Enumeration;
import java.util.Locale;
import java.lang.String;

class StringUtilsTest {
  String taint() { return "tainted"; }

  String[] taintArray() { return null; }

  Locale taintLocale() { return null; }

  Collection<String> taintedCollection() { return null; }

  Enumeration<String> taintedEnumeration() { return null; }

  void sink(Object o) {}

  void test() throws Exception {
    sink(StringUtils.addStringToArray(null, taint())); // $hasTaintFlow

    sink(StringUtils.addStringToArray(taintArray(), "")); // $hasTaintFlow

    sink(StringUtils.applyRelativePath("/", taint())); // $hasTaintFlow
    sink(StringUtils.applyRelativePath(taint(), "../../test")); // $hasTaintFlow

    sink(StringUtils.arrayToCommaDelimitedString(taintArray())); // $hasTaintFlow

    sink(StringUtils.arrayToDelimitedString(taintArray(), ":")); // $hasTaintFlow
    sink(StringUtils.arrayToDelimitedString(null, taint())); // $hasTaintFlow

    sink(StringUtils.capitalize(taint())); // $hasTaintFlow

    sink(StringUtils.cleanPath(taint())); // $hasTaintFlow

    sink(StringUtils.collectionToCommaDelimitedString(taintedCollection()));  // $hasTaintFlow

    sink(StringUtils.collectionToDelimitedString(taintedCollection(), ":")); // $hasTaintFlow
    sink(StringUtils.collectionToDelimitedString(null, taint())); // $hasTaintFlow

    sink(StringUtils.collectionToDelimitedString(taintedCollection(), ":", "", "")); // $hasTaintFlow
    sink(StringUtils.collectionToDelimitedString(null, taint(), "", "")); // $hasTaintFlow
    sink(StringUtils.collectionToDelimitedString(null, ":", taint(), "")); // $hasTaintFlow
    sink(StringUtils.collectionToDelimitedString(null, ":", "", taint())); // $hasTaintFlow

    sink(StringUtils.commaDelimitedListToSet(taint())); // $hasTaintFlow

    sink(StringUtils.commaDelimitedListToStringArray(taint())); // $hasTaintFlow

    sink(StringUtils.concatenateStringArrays(taintArray(), null)); // $hasTaintFlow
    sink(StringUtils.concatenateStringArrays(null, taintArray())); // $hasTaintFlow

    sink(StringUtils.delete(taint(), "")); // $hasTaintFlow

    sink(StringUtils.deleteAny(taint(), "")); // $hasTaintFlow

    sink(StringUtils.delimitedListToStringArray(taint(), ":")); // $hasTaintFlow
    sink(StringUtils.delimitedListToStringArray(taint(), ":", ".")); // $hasTaintFlow

    sink(StringUtils.getFilename(taint())); // $hasTaintFlow

    sink(StringUtils.getFilenameExtension(taint())); // $hasTaintFlow

    sink(StringUtils.mergeStringArrays(taintArray(), null)); // $hasTaintFlow
    sink(StringUtils.mergeStringArrays(null, taintArray())); // $hasTaintFlow

    sink(StringUtils.parseLocale(taint()));

    sink(StringUtils.parseLocaleString(taint()));

    sink(StringUtils.parseTimeZoneString(taint()));

    sink(StringUtils.quote(taint())); // $hasTaintFlow

    sink(StringUtils.quoteIfString(taint())); // $hasTaintFlow

    sink(StringUtils.removeDuplicateStrings(taintArray())); // $hasTaintFlow

    sink(StringUtils.replace(taint(), "", "")); // $hasTaintFlow
    sink(StringUtils.replace("", "", taint())); // $hasTaintFlow

    sink(StringUtils.sortStringArray(taintArray())); // $hasTaintFlow

    sink(StringUtils.split(taint(), "")); // $hasTaintFlow

    sink(StringUtils.splitArrayElementsIntoProperties(taintArray(), "")); // $hasTaintFlow
    sink(StringUtils.splitArrayElementsIntoProperties(taintArray(), "", "")); // $hasTaintFlow

    sink(StringUtils.stripFilenameExtension(taint())); // $hasTaintFlow

    sink(StringUtils.tokenizeToStringArray(taint(), "")); // $hasTaintFlow
    sink(StringUtils.tokenizeToStringArray(taint(), "", true, true)); // $hasTaintFlow

    sink(StringUtils.toLanguageTag(taintLocale()));

    sink(StringUtils.toStringArray(taintedCollection())); // $hasTaintFlow

    sink(StringUtils.toStringArray(taintedEnumeration())); // $hasTaintFlow

    sink(StringUtils.trimAllWhitespace(taint())); // $hasTaintFlow

    sink(StringUtils.trimArrayElements(taintArray())); // $hasTaintFlow

    sink(StringUtils.trimLeadingCharacter(taint(), 'a')); // $hasTaintFlow

    sink(StringUtils.trimLeadingWhitespace(taint())); // $hasTaintFlow

    sink(StringUtils.trimTrailingCharacter(taint(), 'a')); // $hasTaintFlow

    sink(StringUtils.trimTrailingWhitespace(taint())); // $hasTaintFlow

    sink(StringUtils.trimWhitespace(taint())); // $hasTaintFlow

    sink(StringUtils.uncapitalize(taint())); // $hasTaintFlow

    sink(StringUtils.unqualify(taint())); // $hasTaintFlow

    sink(StringUtils.unqualify(taint(), '.')); // $hasTaintFlow

    sink(StringUtils.uriDecode(taint(), java.nio.charset.StandardCharsets.UTF_8)); // $hasTaintFlow
  }
}
