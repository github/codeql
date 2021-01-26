import ruby
import codeql_ruby.ast.internal.TreeSitter

query predicate callsWithNoReceiverArgumentsOrBlock(Call c, string name) {
  name = c.getMethodName() and
  not exists(c.getReceiver()) and
  not exists(c.getAnArgument()) and
  not exists(c.getBlock())
}

query predicate callsWithScopeResolutionName(Call c, ScopeResolution sr) {
  sr = c.getMethodScopeResolution()
}

query predicate callsWithArguments(Call c, string name, int n, Expr argN) {
  name = c.getMethodName() and
  argN = c.getArgument(n)
}

query predicate callsWithReceiver(Call c, Expr rcv) { rcv = c.getReceiver() }

query predicate callsWithBlock(Call c, Block b) { b = c.getBlock() }

query predicate yieldCalls(YieldCall c) { any() }

query predicate superCalls(SuperCall c) { any() }

query predicate superCallsWithArguments(SuperCall c, int n, Expr argN) { argN = c.getArgument(n) }

query predicate superCallsWithBlock(SuperCall c, Block b) { b = c.getBlock() }
