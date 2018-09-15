/**
 * @name Enabling `nodeIntegration` or `nodeIntegrationInWorker` for Electron web content
 * @description Enabling `nodeIntegration` or `nodeIntegrationInWorker` can expose the application to remote code execution.
 * @kind problem
 * @problem.severity warning
 * @id js/enabling-electron-renderer-node-integration
 * @tags security
 *       frameworks/electron
 */

import javascript

/**
 * Gets a warning message for `pref` if one of the `nodeIntegration` features is enabled.
 */
string getNodeIntegrationWarning(Electron::WebPreferences pref) {
	exists (string feature |
		feature = "nodeIntegration" or
		feature = "nodeIntegrationInWorker" |
		pref.getAPropertyWrite(feature).getRhs().mayHaveBooleanValue(true) and
		result = "The `" + feature + "` feature has been enabled."
	)
	or
	exists (string feature |
		feature = "nodeIntegration" |
		not exists(pref.getAPropertyWrite(feature)) and
		result = "The `" + feature + "` feature is enabled by default."
	)
}

from Electron::WebPreferences preferences
select preferences, getNodeIntegrationWarning(preferences)