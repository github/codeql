/**
 * @id cpp/microsoft/public/typo/bad-wchar
 * @name Initialization of bad wide char
 * @description wchar_t should be initialized with L prefix but might be initialized inside single quote. E.g. 'L\0' instead of L'\0'
 * @kind problem
 * @problem.severity error
 * @precision high
 * @tags security
 */

import cpp

/**
 * Check where wchar_t is initalized wrong.
 * E.g. wchar_t a = 'LZ' (bad) instead of L'Z' (good)
 */
predicate badWchar(CharLiteral cl) {
  cl.getActualType().hasName("wchar_t") and
  cl.getValueText().regexpMatch("'L.+'") // wchar_t getValueText() generally looks like L'Z' or 'L\0'. but if it is 'LZ' or 'L\0', this might be bad
}

/**
 * when codeql can't figure out what underlying type it is, it will default to int. Scenarios unique_ptr, it seems to have hard time figuring out...
 * we can check for others like 'LZ' or 'LA' but you will get alot of false positive since there can be enum :int with 'LZ' field etc
 * E.g. unique_ptr<PWSTR>('L\0'). If codeql couldnt figureout what unique_ptr is pointing to it will set it int.
 */
predicate wcharNullOnNonWchar(CharLiteral cl) {
  cl.getValue().toInt() = 19456 // 19456 (0x4c00) is 'L\0'
}

from CharLiteral cl, string msg
where
  (
    wcharNullOnNonWchar(cl) or
    badWchar(cl)
  ) and
  msg =
    " Varible of type wchar_t maybe have been initialized with a typo. " + cl.getValueText() +
      " should be L'" + cl.getValueText().substring(2, cl.getValueText().length())
select cl, "$@: " + msg, cl, cl.getValueText()
