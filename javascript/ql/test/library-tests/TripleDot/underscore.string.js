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
  sink(s.strip(source("s32"),"charsToStrim")); // $ hasTaintFlow=s32
  sink(s.lstrip(source("s33"),"charsToStrim")); // $ hasTaintFlow=s33
  sink(s.rstrip(source("s34"),"charsToStrim")); // $ hasTaintFlow=s34
  sink(s.camelcase(source("s35"))); // $ hasTaintFlow=s35
}

function strToArray() {
  sink(s.chop(source("s1"), 3)[0]); // $ hasTaintFlow=s1
  sink(s.chars(source("s2")[0])); // $ hasTaintFlow=s2
  sink(s.words(source("s3")[0])); // $ hasTaintFlow=s3
  sink(s.lines(source("s7")[0])); // $ hasTaintFlow=s7
}

function arrayToStr() {
  sink(s.toSentence([source("s1")])); // $ hasTaintFlow=s1
  sink(s.toSentenceSerial([source("s2")])); // $ hasTaintFlow=s2
}

function multiSource() {
  sink(s.insert("str", 4, source("s1"))); // $ hasTaintFlow=s1
  sink(s.insert(source("s2"), 4, "")); // $ hasTaintFlow=s2

  sink(s.replaceAll("astr", "a", source("s3"))); // $ hasTaintFlow=s3
  sink(s.replaceAll(source("s4"), "a", "")); // $ hasTaintFlow=s4

  sink(s.join(",", source("s5"), "str")); // $ hasTaintFlow=s5
  sink(s.join(",", "str", source("s6"))); // $ hasTaintFlow=s6

  sink(s.splice(source("s7"), 1, 2, "str")); // $ hasTaintFlow=s7
  sink(s.splice("str", 1, 2, source("s8"))); // $ hasTaintFlow=s8

  sink(s.prune(source("s9"), 1, "additional")); // $ hasTaintFlow=s9
  sink(s.prune("base", 1, source("s10"))); // $ hasTaintFlow=s10

  sink(s.pad(source("s11"), 10, "charsToPad", "right")); // $ hasTaintFlow=s11
  sink(s.pad("base", 10, source("s12"), "right")); // $ hasTaintFlow=s12

  sink(s.lpad(source("s13"), 10, "charsToPad")); // $ hasTaintFlow=s13
  sink(s.lpad("base", 10, source("s14"))); // $ hasTaintFlow=s14

  sink(s.rpad(source("s15"), 10, "charsToPad")); // $ hasTaintFlow=s15
  sink(s.rpad("base", 10, source("s16"))); // $ hasTaintFlow=s16

  sink(s.repeat(source("s17"), 3, "seperator")); // $ hasTaintFlow=s17
  sink(s.repeat("base", 3, source("s18"))); // $ hasTaintFlow=s18

  sink(s.surround(source("s19"), "wrap")); // $ hasTaintFlow=s19
  sink(s.surround("base", source("s20"))); // $ hasTaintFlow=s20

  sink(s.quote(source("s21"), "quote")); // $ hasTaintFlow=s21
  sink(s.quote("base", source("s22"))); // $ hasTaintFlow=s22

  sink(s.q(source("s23"), "quote")); // $ hasTaintFlow=s23
  sink(s.q("base", source("s24"))); // $ hasTaintFlow=s24

  sink(s.rjust(source("s25"), 10, "charsToPad")); // $ hasTaintFlow=s25
  sink(s.rjust("base", 10, source("s26"))); // $ hasTaintFlow=s26

  sink(s.ljust(source("s27"), 10, "charsToPad")); // $ hasTaintFlow=s27
  sink(s.ljust("base", 10, source("s28"))); // $ hasTaintFlow=s28
}

function chaining() {
  sink(s(source("s1"))
      .slugify().capitalize().decapitalize().clean().cleanDiacritics()    
      .swapCase().escapeHTML().unescapeHTML().wrap().dedent()
      .reverse().pred().succ().titleize().camelize().classify()
      .underscored().dasherize().humanize().trim().ltrim().rtrim()
      .truncate().sprintf().strRight().strRightBack()
      .strLeft().strLeftBack().stripTags().unquote().value()); // $ hasTaintFlow=s1

  sink(s(source("s2"))
      .insert(4, source("s3")).replaceAll("a", source("s4"))
      .join(",", source("s5")).splice(1, 2, source("s6"))
      .prune(1, source("s7")).pad(10, source("s8"), "right")
      .lpad(10, source("s9")).rpad(10, source("s10"))
      .repeat(3, source("s11")).surround(source("s12"))
      .quote(source("s13")).value()); // $ hasTaintFlow=s2 hasTaintFlow=s3 hasTaintFlow=s4 hasTaintFlow=s5 hasTaintFlow=s6 hasTaintFlow=s7 hasTaintFlow=s8 hasTaintFlow=s9 hasTaintFlow=s10 hasTaintFlow=s11 hasTaintFlow=s12 hasTaintFlow=s13

  sink(s(source("s14")).toUpperCase().toLowerCase().replace().slice(1).substring(1).substr(1).concat(source("s15")).split()); // $ hasTaintFlow=s14 hasTaintFlow=s15

  sink(s(source("s16"))
  .strip().lstrip().rstrip().camelcase()
  .q(source("s17")).ljust(10, source("s18"))
  .rjust(10, source("s19"))); // $ hasTaintFlow=s16 hasTaintFlow=s17 hasTaintFlow=s18 hasTaintFlow=s19

  sink(s(source("s20")).tap(function(value) { 
    return value + source("s21"); 
  }).value()); // $ hasTaintFlow=s20 hasTaintFlow=s21
}

function mapTests(){
  sink(s.map(source("s1"), (x) => {return x + source("s2");})); // $ hasTaintFlow=s1 hasTaintFlow=s2
  s.map(source("s1"), (x) => { sink(x); return x;}); // $ hasTaintFlow=s1
}
