// BAD
predicate isXML() { any() }

// GOOD [ AES is exceptional ]
predicate isAES() { any() }

// BAD
newtype TXMLElements =
  TXmlElement() or // GOOD
  TXMLElement() // BAD

// GOOD [ FALSE POSITIVE ]
newtype TIRFunction =
  MkIRFunction()
