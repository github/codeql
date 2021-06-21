/**
 * @name Enabling Electron allowRunningInsecureContent
 * @description Enabling allowRunningInsecureContent can allow remote code execution.
 * @kind problem
 * @problem.severity error
 * @security-severity 8.8
 * @precision very-high
 * @tags security
 *       frameworks/electron
 *       external/cwe/cwe-494
 * @id js/enabling-electron-insecure-content
 */

import javascript

from DataFlow::PropWrite allowRunningInsecureContent, Electron::WebPreferences preferences
where
  allowRunningInsecureContent = preferences.getAPropertyWrite("allowRunningInsecureContent") and
  allowRunningInsecureContent.getRhs().mayHaveBooleanValue(true)
select allowRunningInsecureContent, "Enabling allowRunningInsecureContent is strongly discouraged."
