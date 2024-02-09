import java

RefType getADatabaseSubtype(RefType rt) {
  extendsReftype(rt, result)
  or
  implInterface(rt, result)
}

from Parameter p, RefType paramType, KotlinType paramKtType, string paramAncestorType
where
  p.fromSource() and
  p.getCallable().getName() = "user" and
  p.getType() = paramType and
  p.getKotlinType() = paramKtType and
  // Stringified to avoid printing the source-location (i.e. stdlib path) of `Any?`
  getADatabaseSubtype+(paramType).toString() = paramAncestorType
select p, paramType, paramKtType, paramAncestorType
