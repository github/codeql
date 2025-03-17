var s = require("underscore.string");

function strToStr() {
  sink(s.slugify(source("s1"))); // $ hasTaintFlow=s1
  sink(s.capitalize(source("s2"))); // $ hasTaintFlow=s2
  sink(s.decapitalize(source("s3"))); // $ hasTaintFlow=s3
  sink(s.clean(source("s4"))); // $ hasTaintFlow=s4
  sink(s.cleanDiacritics(source("s5"))); // $ hasTaintFlow=s5
  sink(s.swapCase(source("s6"))); // $ hasTaintFlow=s6
  sink(s.escapeHTML(source("s7"))); // $ hasTaintFlow=s7
  sink(s.unescapeHTML(source("s8"))); // $ hasTaintFlow=s8
  sink(s.wrap(source("s9"), {})); // $ hasTaintFlow=s9
  sink(s.dedent(source("s10"), "  ")); // $ hasTaintFlow=s10
  sink(s.reverse(source("s11"))); // $ hasTaintFlow=s11
  sink(s.pred(source("s12"))); // $ hasTaintFlow=s12
  sink(s.succ(source("s13"))); // $ hasTaintFlow=s13
  sink(s.titleize(source("s14"))); // $ hasTaintFlow=s14
  sink(s.camelize(source("s15"))); // $ hasTaintFlow=s15
  sink(s.classify(source("s16"))); // $ hasTaintFlow=s16
  sink(s.underscored(source("s17"))); // $ hasTaintFlow=s17
  sink(s.dasherize(source("s18"))); // $ hasTaintFlow=s18
  sink(s.humanize(source("s19"))); // $ hasTaintFlow=s19
  sink(s.trim(source("s20"),"charsToStrim")); // $ hasTaintFlow=s20
  sink(s.ltrim(source("s21"),"charsToStrim")); // $ hasTaintFlow=s21
  sink(s.rtrim(source("s22"),"charsToStrim")); // $ hasTaintFlow=s22
  sink(s.truncate(source("s23"), 10)); // $ hasTaintFlow=s23
  sink(s.sprintf(source("s24"), 1.17)); // $ hasTaintFlow=s24
  sink(s.strRight(source("s25"), "pattern")); // $ hasTaintFlow=s25
  sink(s.strRightBack(source("s26"), "pattern")); // $ hasTaintFlow=s26
  sink(s.strLeft(source("s27"), "pattern")); // $ hasTaintFlow=s27
  sink(s.strLeftBack(source("s28"), "pattern")); // $ hasTaintFlow=s28
  sink(s.stripTags(source("s29"))); // $ hasTaintFlow=s29
  sink(s.unquote(source("s30"), "quote")); // $ hasTaintFlow=s30
  sink(s.map(source("s31"), (x) => {return x;})); // $ hasTaintFlow=s31
}

function strToArray() {
  sink(s.chop(source("s1"), 3)[0]); // $ hasTaintFlow=s1
  sink(s.chars(source("s2")[0])); // $ hasTaintFlow=s2
  sink(s.words(source("s3")[0])); // $ hasTaintFlow=s3
  sink(s.lines(source("s7")[0])); // $ hasTaintFlow=s7
}
