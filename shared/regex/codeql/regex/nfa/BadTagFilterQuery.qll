/**
 * Provides predicates for reasoning about bad tag filter vulnerabilities.
 */

private import NfaUtils as NfaUtils
private import RegexpMatching as RM
private import codeql.regex.RegexTreeView

/**
 * Module implementing classes and predicates reasoing about bad tag filter vulnerabilities.
 */
module Make<RegexTreeViewSig TreeImpl> {
  private import TreeImpl
  import RM::Make<TreeImpl>

  /**
   * Holds if the regexp `root` should be tested against `str`.
   * Implements the `isRegexpMatchingCandidateSig` signature from `RegexpMatching`.
   * `ignorePrefix` toggles whether the regular expression should be treated as accepting any prefix if it's unanchored.
   * `testWithGroups` toggles whether it's tested which groups are filled by a given input string.
   */
  private predicate isBadTagFilterCandidate(
    RootTerm root, string str, boolean ignorePrefix, boolean testWithGroups
  ) {
    // the regexp must mention "<" and ">" explicitly.
    (
      forall(string angleBracket | angleBracket = ["<", ">"] |
        any(RegExpConstant term | term.getValue().matches("%" + angleBracket + "%")).getRootTerm() =
          root
      )
      or
      // or contain "-->" / "--!>" / "<--" / "<!--"
      root =
        any(RegExpConstant term | term.getValue() = ["-->", "--!>", "<--", "<!--"]).getRootTerm()
    ) and
    ignorePrefix = true and
    (
      str = ["<!-- foo -->", "<!-- foo --!>", "<!- foo ->", "<foo>", "<script>"] and
      testWithGroups = true
      or
      str =
        [
          "<!-- foo -->", "<!- foo ->", "<!-- foo --!>", "<!-- foo\n -->", "<script>foo</script>",
          "<script \n>foo</script>", "<script >foo\n</script>", "<foo ></foo>", "<foo>",
          "<foo src=\"foo\"></foo>", "<script>", "<script src=\"foo\"></script>",
          "<script src='foo'></script>", "<SCRIPT>foo</SCRIPT>", "<script\tsrc=\"foo\"/>",
          "<script\tsrc='foo'></script>", "<sCrIpT>foo</ScRiPt>",
          "<script src=\"foo\">foo</script >", "<script src=\"foo\">foo</script foo=\"bar\">",
          "<script src=\"foo\">foo</script\t\n bar>", "-->", "--!>", "--"
        ] and
      testWithGroups = false
    )
  }

  /**
   * A regexp that matches some string from the `isBadTagFilterCandidate` predicate.
   */
  class HtmlMatchingRegExp extends RootTerm {
    HtmlMatchingRegExp() { RegexpMatching<isBadTagFilterCandidate/4>::matches(this, _) }

    /** Holds if this regexp matched `str`, where `str` is one of the string from `isBadTagFilterCandidate`. */
    predicate matches(string str) { RegexpMatching<isBadTagFilterCandidate/4>::matches(this, str) }

    /** Holds if this regexp fills capture group `g' when matching `str', where `str` is one of the string from `isBadTagFilterCandidate`. */
    predicate fillsCaptureGroup(string str, int g) {
      RegexpMatching<isBadTagFilterCandidate/4>::fillsCaptureGroup(this, str, g)
    }
  }

  /**
   * Holds if `regexp` matches some HTML tags, but misses some HTML tags that it should match.
   *
   * When adding a new case to this predicate, make sure the test string used in `matches(..)` calls are present in `HTMLMatchingRegExp::test` / `HTMLMatchingRegExp::testWithGroups`.
   */
  predicate isBadRegexpFilter(HtmlMatchingRegExp regexp, string msg) {
    // CVE-2021-33829 - matching both "<!-- foo -->" and "<!-- foo --!>", but in different capture groups
    regexp.matches("<!-- foo -->") and
    regexp.matches("<!-- foo --!>") and
    exists(int a, int b | a != b |
      regexp.fillsCaptureGroup("<!-- foo -->", a) and
      // <!-- foo --> might be ambiguously parsed (matching both capture groups), and that is ok here.
      regexp.fillsCaptureGroup("<!-- foo --!>", b) and
      not regexp.fillsCaptureGroup("<!-- foo --!>", a) and
      msg =
        "Comments ending with --> are matched differently from comments ending with --!>. The first is matched with capture group "
          + a + " and comments ending with --!> are matched with capture group " +
          strictconcat(int i | regexp.fillsCaptureGroup("<!-- foo --!>", i) | i.toString(), ", ") +
          "."
    )
    or
    // CVE-2020-17480 - matching "<!-- foo -->" and other tags, but not "<!-- foo --!>".
    exists(int group, int other |
      group != other and
      regexp.fillsCaptureGroup("<!-- foo -->", group) and
      regexp.fillsCaptureGroup("<foo>", other) and
      not regexp.matches("<!-- foo --!>") and
      not regexp.fillsCaptureGroup("<!-- foo -->", any(int i | i != group)) and
      not regexp.fillsCaptureGroup("<!- foo ->", group) and
      not regexp.fillsCaptureGroup("<foo>", group) and
      not regexp.fillsCaptureGroup("<script>", group) and
      msg =
        "This regular expression only parses --> (capture group " + group +
          ") and not --!> as an HTML comment end tag."
    )
    or
    // CVE-2021-4231 - matching only "-->" but not "--!>".
    regexp.matches("-->") and
    not regexp.matches("--!>") and
    not regexp.matches("--") and
    msg = "This regular expression only parses --> and not --!> as a HTML comment end tag."
    or
    regexp.matches("<!-- foo -->") and
    not regexp.matches("<!-- foo\n -->") and
    not regexp.matches("<!- foo ->") and
    not regexp.matches("<foo>") and
    not regexp.matches("<script>") and
    msg = "This regular expression does not match comments containing newlines."
    or
    regexp.matches("<script>foo</script>") and
    regexp.matches("<script src=\"foo\"></script>") and
    not regexp.matches("<foo ></foo>") and
    (
      not regexp.matches("<script \n>foo</script>") and
      msg = "This regular expression matches <script></script>, but not <script \\n></script>"
      or
      not regexp.matches("<script >foo\n</script>") and
      msg = "This regular expression matches <script>...</script>, but not <script >...\\n</script>"
    )
    or
    regexp.matches("<script>foo</script>") and
    regexp.matches("<script src=\"foo\"></script>") and
    not regexp.matches("<script src='foo'></script>") and
    not regexp.matches("<foo>") and
    msg =
      "This regular expression does not match script tags where the attribute uses single-quotes."
    or
    regexp.matches("<script>foo</script>") and
    regexp.matches("<script src='foo'></script>") and
    not regexp.matches("<script src=\"foo\"></script>") and
    not regexp.matches("<foo>") and
    msg =
      "This regular expression does not match script tags where the attribute uses double-quotes."
    or
    regexp.matches("<script>foo</script>") and
    regexp.matches("<script src='foo'></script>") and
    not regexp.matches("<script\tsrc='foo'></script>") and
    not regexp.matches("<foo>") and
    not regexp.matches("<foo src=\"foo\"></foo>") and
    msg =
      "This regular expression does not match script tags where tabs are used between attributes."
    or
    regexp.matches("<script>foo</script>") and
    not isIgnoreCase(regexp) and
    not regexp.matches("<foo>") and
    not regexp.matches("<foo ></foo>") and
    (
      not regexp.matches("<SCRIPT>foo</SCRIPT>") and
      msg = "This regular expression does not match upper case <SCRIPT> tags."
      or
      not regexp.matches("<sCrIpT>foo</ScRiPt>") and
      regexp.matches("<SCRIPT>foo</SCRIPT>") and
      msg = "This regular expression does not match mixed case <sCrIpT> tags."
    )
    or
    regexp.matches("<script src=\"foo\"></script>") and
    not regexp.matches("<foo>") and
    not regexp.matches("<foo ></foo>") and
    (
      not regexp.matches("<script src=\"foo\">foo</script >") and
      msg = "This regular expression does not match script end tags like </script >."
      or
      not regexp.matches("<script src=\"foo\">foo</script foo=\"bar\">") and
      msg = "This regular expression does not match script end tags like </script foo=\"bar\">."
      or
      not regexp.matches("<script src=\"foo\">foo</script\t\n bar>") and
      msg = "This regular expression does not match script end tags like </script\\t\\n bar>."
    )
  }
}
