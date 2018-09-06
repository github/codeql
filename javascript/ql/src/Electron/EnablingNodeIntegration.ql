/**
 * @name Enabling nodeIntegration and nodeIntegrationInWorker in webPreferences
 * @description Enabling nodeIntegration and nodeIntegrationInWorker could expose your app to remote code execution.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @tags security
 *       frameworks/electron
 * @id js/enabling-electron-renderer-node-integration
 */

import javascript

string checkWebOptions(DataFlow::PropWrite prop, Electron::WebPreferences pref) {
	(prop = pref.getAPropertyWrite("nodeIntegration") and 
	 prop.getRhs().mayHaveBooleanValue(true) and
	 result = "nodeIntegration property may have been enabled on this object that could result in RCE")
	or
	(prop = pref.getAPropertyWrite("nodeIntegrationInWorker") and
	 prop.getRhs().mayHaveBooleanValue(true) and
	 result = "nodeIntegrationInWorker property may have been enabled on this object that could result in RCE")
	or
	(not exists(pref.asExpr().(ObjectExpr).getPropertyByName("nodeIntegration")) and
	 result = "nodeIntegration is enabled by default in WebPreferences object that could result in RCE")
}

from DataFlow::PropWrite property, Electron::WebPreferences preferences 
select preferences,checkWebOptions(property, preferences)