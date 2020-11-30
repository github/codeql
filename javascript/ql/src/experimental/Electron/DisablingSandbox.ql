/**
 * @name Disabling sandbox for Electron renderer processes
 * @description Disabling sandbox can enable website to escalate privileges and perform remote code execution.
 * @kind problem
 * @problem.severity error
 * @precision very-high
 * @tags security
 *       frameworks/electron
 * @id js/disabling-electron-renderer-sandbox
 */

import javascript

// TODO: 
//  - Sandbox can be enabled globally by calling app.enableSandbox(), query should be able to detect that
//  - Sandbox is not enabled by default, query should detect that. 

from DataFlow::PropWrite contextIsolation, Electron::WebPreferences preferences
where
  contextIsolation = preferences.getAPropertyWrite("sandbox") and
  contextIsolation.getRhs().mayHaveBooleanValue(false)
select contextIsolation, "Disabling sandbox is strongly discouraged."
