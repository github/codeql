import cpp

// This test case demonstrates that when a header file invokes a macro, we get
// a `MacroInvocation` in the database for each preprocessor context in which
// the header file is used. This can cause performance issues on large
// databases, where there may be hundreds of such contexts.
from MacroInvocation mi
where mi.getMacroName() = "MY_MACRO"
select mi
