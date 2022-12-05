let parser = XMLParser(data: remoteData) // BAD (parser explicitly enables external entities)
parser.shouldResolveExternalEntities = true
