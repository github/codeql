import cpp

/**
 * DEPRECATED: use `semmle.code.cpp.models.implementations.Strcat.qll` instead.
 *
 * A function that concatenates the string from its second argument
 * to the string from its first argument, for example `strcat`.
 */
class StrcatFunction extends Function {
  StrcatFunction() {
    getName() =
      ["strcat", // strcat(dst, src)
          "strncat", // strncat(dst, src, max_amount)
          "wcscat", // wcscat(dst, src)
          "_mbscat", // _mbscat(dst, src)
          "wcsncat", // wcsncat(dst, src, max_amount)
          "_mbsncat", // _mbsncat(dst, src, max_amount)
          "_mbsncat_l"] // _mbsncat_l(dst, src, max_amount, locale)
  }
}
