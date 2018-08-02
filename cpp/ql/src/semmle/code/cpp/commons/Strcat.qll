import cpp

/**
 * DEPRECATED: use `semmle.code.cpp.models.implementations.Strcat.qll` instead.
 * 
 * A function that concatenates the string from its second argument
 * to the string from its first argument, for example `strcat`.
 */
class StrcatFunction extends Function {
  StrcatFunction() {
    exists(string name | name = getName()|
      name = "strcat" // strcat(dst, src)
      or name = "strncat" // strncat(dst, src, max_amount)
      or name = "wcscat" // wcscat(dst, src)
      or name = "_mbscat" // _mbscat(dst, src)
      or name = "wcsncat" // wcsncat(dst, src, max_amount)
      or name = "_mbsncat" // _mbsncat(dst, src, max_amount)
      or name = "_mbsncat_l" // _mbsncat_l(dst, src, max_amount, locale)
    )
  }
}