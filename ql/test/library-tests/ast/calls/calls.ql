import ruby
import codeql_ruby.ast.internal.TreeSitter

private string getMethodName(Call c) {
  result = c.getMethodName()
  or
  not exists(c.getMethodName()) and result = "(none)"
}

query predicate callsWithNoReceiverArgumentsOrBlock(Call c, string name) {
  name = getMethodName(c) and
  not exists(c.getReceiver()) and
  not exists(c.getAnArgument()) and
  not exists(c.getBlock())
}

query predicate callsWithArguments(Call c, string name, int n, Expr argN) {
  name = getMethodName(c) and
  argN = c.getArgument(n)
}

query predicate callsWithReceiver(Call c, Expr rcv) { rcv = c.getReceiver() }

query predicate callsWithBlock(Call c, Block b) { b = c.getBlock() }

query predicate yieldCalls(YieldCall c) { any() }

query predicate superCalls(SuperCall c) { any() }

query predicate superCallsWithArguments(SuperCall c, int n, Expr argN) { argN = c.getArgument(n) }

query predicate superCallsWithBlock(SuperCall c, Block b) { b = c.getBlock() }
