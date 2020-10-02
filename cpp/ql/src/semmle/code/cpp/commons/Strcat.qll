import cpp

/**
 * DEPRECATED: use `semmle.code.cpp.models.implementations.Strcat.qll` instead.
 *
 * A function that concatenates the string from its second argument
 * to the string from its first argument, for example `strcat`.
 */
class StrcatFunction extends Function {
  StrcatFunction() {
    // strcat(dst, src)
    // strncat(dst, src, max_amount)
    // wcscat(dst, src)
    // _mbscat(dst, src)
    // wcsncat(dst, src, max_amount)
    // _mbsncat(dst, src, max_amount)
    // _mbsncat_l(dst, src, max_amount, locale)
    getName() = ["strcat", "strncat", "wcscat", "_mbscat", "wcsncat", "_mbsncat", "_mbsncat_l"]
  }
}
