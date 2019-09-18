/**
 * @name Disabling Electron webSecurity
 * @description Disabling webSecurity can cause critical security vulnerabilities.
 * @kind problem
 * @problem.severity error
 * @precision very-high
 * @tags security
 *       frameworks/electron
 * @id js/disabling-electron-websecurity
 */

import javascript

from DataFlow::PropWrite webSecurity, Electron::WebPreferences preferences
where
  webSecurity = preferences.getAPropertyWrite("webSecurity") and
  webSecurity.getRhs().mayHaveBooleanValue(false)
select webSecurity, "Disabling webSecurity is strongly discouraged."
