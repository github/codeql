let parser = XMLParser(data: remoteData) // GOOD (parser explicitly disables external entities)
parser.shouldResolveExternalEntities = false
