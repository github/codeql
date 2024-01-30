import java

query predicate varAcc(VarAccess va) { va.getFile().isSourceFile() }

query predicate extensionReceiverAcc(ExtensionReceiverAccess va) { any() }

query predicate instAcc(InstanceAccess ia) { any() }

query predicate instAccQualifier(InstanceAccess ia, Expr e) { ia.getQualifier() = e }
