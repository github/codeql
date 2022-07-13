// BAD
predicate isXML() { any() }

// GOOD [ AES is exceptional ]
predicate isAES() { any() }

// BAD
newtype TXMLElements =
  TXmlElement() or // GOOD
  TXMLElement() // BAD

// GOOD
newtype TIRFunction = MkIRFunction()
