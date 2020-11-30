/**
 * @name Disabling Context Isolation in Electron
 * @description Disabling Context Isolation can enable website to escalate its privileges and access internal Electron APIs.
 * @kind problem
 * @problem.severity error
 * @precision very-high
 * @tags security
 *       frameworks/electron
 * @id js/disabling-electron-context-isolation
 */

import javascript

// TODO: Below Electron 12 the Context Isolation needs to be enabled manually. 
//       If there is reliable way to determine Electron version, this query 
//       could be extended to check this case. 

from DataFlow::PropWrite contextIsolation, Electron::WebPreferences preferences
where
  contextIsolation = preferences.getAPropertyWrite("contextIsolation") and
  contextIsolation.getRhs().mayHaveBooleanValue(false)
select contextIsolation, "Disabling contextIsolation is strongly discouraged."
