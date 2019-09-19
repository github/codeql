import csharp
import Common

query predicate nodeEnclosing(SourceControlFlowNode n, Callable c) { c = n.getEnclosingCallable() }

query predicate blockEnclosing(SourceBasicBlock bb, Callable c) { c = bb.getCallable() }
