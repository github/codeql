// BAD
predicate isXML() { any() } // $ Alert

// GOOD [ AES is exceptional ]
predicate isAES() { any() }

// BAD
newtype TXMLElements = // $ Alert
  TXmlElement() or // GOOD
  TXMLElement() // $ Alert // BAD

// GOOD
newtype TIRFunction = MkIRFunction()
