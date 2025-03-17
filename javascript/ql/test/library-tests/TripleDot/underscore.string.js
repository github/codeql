var s = require("underscore.string");

function strToStr() {
  sink(s.slugify(source("s1"))); // $ MISSING: hasTaintFlow=s1
  sink(s.capitalize(source("s2"))); // $ MISSING: hasTaintFlow=s2
  sink(s.decapitalize(source("s3"))); // $ MISSING: hasTaintFlow=s3
  sink(s.clean(source("s4"))); // $ MISSING: hasTaintFlow=s4
  sink(s.cleanDiacritics(source("s5"))); // $ MISSING: hasTaintFlow=s5
  sink(s.swapCase(source("s6"))); // $ MISSING: hasTaintFlow=s6
  sink(s.escapeHTML(source("s7"))); // $ MISSING: hasTaintFlow=s7
  sink(s.unescapeHTML(source("s8"))); // $ MISSING: hasTaintFlow=s8
  sink(s.wrap(source("s9"), {})); // $ MISSING: hasTaintFlow=s9
  sink(s.dedent(source("s10"), "  ")); // $ MISSING: hasTaintFlow=s10
  sink(s.reverse(source("s11"))); // $ MISSING: hasTaintFlow=s11
  sink(s.pred(source("s12"))); // $ MISSING: hasTaintFlow=s12
  sink(s.succ(source("s13"))); // $ MISSING: hasTaintFlow=s13
  sink(s.titleize(source("s14"))); // $ MISSING: hasTaintFlow=s14
  sink(s.camelize(source("s15"))); // $ MISSING: hasTaintFlow=s15
  sink(s.classify(source("s16"))); // $ MISSING: hasTaintFlow=s16
  sink(s.underscored(source("s17"))); // $ MISSING: hasTaintFlow=s17
  sink(s.dasherize(source("s18"))); // $ MISSING: hasTaintFlow=s18
  sink(s.humanize(source("s19"))); // $ MISSING: hasTaintFlow=s19
  sink(s.trim(source("s20"),"charsToStrim")); // $ MISSING: hasTaintFlow=s20
  sink(s.ltrim(source("s21"),"charsToStrim")); // $ MISSING: hasTaintFlow=s21
  sink(s.rtrim(source("s22"),"charsToStrim")); // $ MISSING: hasTaintFlow=s22
  sink(s.truncate(source("s23"), 10)); // $ MISSING: hasTaintFlow=s23
  sink(s.sprintf(source("s24"), 1.17)); // $ MISSING: hasTaintFlow=s24
  sink(s.strRight(source("s25"), "pattern")); // $ MISSING: hasTaintFlow=s25
  sink(s.strRightBack(source("s26"), "pattern")); // $ MISSING: hasTaintFlow=s26
  sink(s.strLeft(source("s27"), "pattern")); // $ MISSING: hasTaintFlow=s27
  sink(s.strLeftBack(source("s28"), "pattern")); // $ MISSING: hasTaintFlow=s28
  sink(s.stripTags(source("s29"))); // $ MISSING: hasTaintFlow=s29
  sink(s.unquote(source("s30"), "quote")); // $ MISSING: hasTaintFlow=s30
  sink(s.map(source("s31"), (x) => {return x;})); // $ MISSING: hasTaintFlow=s31
}
