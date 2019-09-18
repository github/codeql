/**
 * @name Enabling Node.js integration for Electron web content renderers
 * @description Enabling `nodeIntegration` or `nodeIntegrationInWorker` can expose the application to remote code execution.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id js/enabling-electron-renderer-node-integration
 * @tags security
 *       frameworks/electron
 *       external/cwe/cwe-094
 */

import javascript

/**
 * Gets a warning message for `pref` if one of the `nodeIntegration` features is enabled.
 */
string getNodeIntegrationWarning(Electron::WebPreferences pref) {
  exists(string feature |
    feature = "nodeIntegration" or
    feature = "nodeIntegrationInWorker"
  |
    pref.getAPropertyWrite(feature).getRhs().mayHaveBooleanValue(true) and
    result = "The `" + feature + "` feature has been enabled."
  )
  or
  exists(string feature | feature = "nodeIntegration" |
    not exists(pref.getAPropertyWrite(feature)) and
    result = "The `" + feature + "` feature is enabled by default."
  )
}

from Electron::WebPreferences preferences
select preferences, getNodeIntegrationWarning(preferences)
