import javascript

query predicate browserObject(Electron::BrowserObject obj) { any() }

query predicate clientRequest_getADataNode(Electron::ElectronClientRequest cr, DataFlow::Node data) {
  cr.getADataNode() = data
}

query predicate clientRequest(Electron::ElectronClientRequest cr) { any() }

query predicate ipcFlow(DataFlow::Node pred, DataFlow::Node succ) {
  exists(DataFlow::AdditionalFlowStep afs | afs.step(pred, succ))
}

query predicate remoteFlowSources(RemoteFlowSource source) { any() }

query predicate webContents(Electron::WebContents wc) { any() }

query predicate webPreferences(Electron::WebPreferences pref) { any() }
