import cpp
import LoopConditionsConst

from Loop l, Expr condition
where
	l.getCondition() = condition
select
	l, condition,
	concat(int val | loopEntryConst(condition, val) | val.toString(), ", "),
	concat(BasicBlock bb | bb.getASuccessor() = l.getStmt() | bb.toString(), ", "),
	concat(l.getStmt().toString(), ", "),
	concat(BasicBlock bb | bb.getASuccessor() = l.getFollowingStmt() | bb.toString(), ", "),
	concat(l.getFollowingStmt().toString(), ", ")

/*
dump a graph of BasicBlocks

import semmle.code.cpp.controlflow.LocalScopeVariableReachability

from BasicBlock pred
select
	pred,
	concat(BasicBlock succ |
		pred.getASuccessor() = succ |
		pred.toString() + " -> " + succ.toString(), ", "),
	concat(BasicBlock succ, boolean predSkip, boolean succSkip |
		bbSuccessorEntryReachesLoopInvariant(pred, succ, predSkip, succSkip) |
		pred.toString() + " (" + predSkip.toString() + ") -> " + succ.toString() + " (" + succSkip.toString() + ")", ", "
	)
*/