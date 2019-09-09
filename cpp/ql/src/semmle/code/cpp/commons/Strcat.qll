import cpp

/**
 * DEPRECATED: use `semmle.code.cpp.models.implementations.Strcat.qll` instead.
 *
 * A function that concatenates the string from its second argument
 * to the string from its first argument, for example `strcat`.
 */
class StrcatFunction extends Function {
  StrcatFunction() {
    exists(string name | name = getName() |
      name = "strcat" or // strcat(dst, src)
      name = "strncat" or // strncat(dst, src, max_amount)
      name = "wcscat" or // wcscat(dst, src)
      name = "_mbscat" or // _mbscat(dst, src)
      name = "wcsncat" or // wcsncat(dst, src, max_amount)
      name = "_mbsncat" or // _mbsncat(dst, src, max_amount)
      name = "_mbsncat_l" // _mbsncat_l(dst, src, max_amount, locale)
    )
  }
}
