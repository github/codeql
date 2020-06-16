import java
import types

/**
 * A 'Sensitive Name' is something that indicates that the name has some sort of security
 * implication associated with it's usage.
 */
bindingset[name]
predicate isSensitiveName(string name) {
  name.matches("%pass%") // also matches password
  or
  name.matches("%tok%") // also matches token
  or
  name.matches("%secret%")
  or
  name.matches("%reset%key%") and not name.matches("%value%") // Reduce false positive from 'keyValue' type of methods from maps
  or
  name.matches("%cred%") // also matches credentials
  or
  name.matches("%auth%") // also matches authentication
  or
  name.matches("%sess%id%") // also matches sessionid
}


/**
  * A UUID created with insecure RNG will itself be tainted.
  */
predicate isTaintedUuidCreation(Expr expSource, Expr expDest) {
  exists(UUIDCreationExp c | c.getAnArgument() = expSource and c = expDest)
}
