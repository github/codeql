/**
 * This module implements the analysis described in the paper:
 *   Valentin Wustholz, Oswaldo Olivo, Marijn J. H. Heule, and Isil Dillig:
 *     Static Detection of DoS Vulnerabilities in
 *     Programs that use Regular Expressions
 *     (Extended Version).
 *   (https://arxiv.org/pdf/1701.04045.pdf)
 *
 * Theorem 3 from the paper describes the basic idea.
 *
 * The following explains the idea using variables and predicate names that are used in the implementation:
 * We consider a pair of repetitions, which we will call `pivot` and `succ`.
 *
 * We create a product automaton of 3-tuples of states (see `StateTuple`).
 * There exists a transition `(a,b,c) -> (d,e,f)` in the product automaton
 * iff there exists three transitions in the NFA `a->d, b->e, c->f` where those three
 * transitions all match a shared character `char`. (see `getAThreewayIntersect`)
 *
 * We start a search in the product automaton at `(pivot, pivot, succ)`,
 * and search for a series of transitions (a `Trace`), such that we end
 * at `(pivot, succ, succ)` (see `isReachableFromStartTuple`).
 *
 * For example, consider the regular expression `/^\d*5\w*$/`.
 * The search will start at the tuple `(\d*, \d*, \w*)` and search
 * for a path to `(\d*, \w*, \w*)`.
 * This path exists, and consists of a single transition in the product automaton,
 * where the three corresponding NFA edges all match the character `"5"`.
 *
 * The start-state in the NFA has an any-transition to itself, this allows us to
 * flag regular expressions such as `/a*$/` - which does not have a start anchor -
 * and can thus start matching anywhere.
 *
 * The implementation is not perfect.
 * It has the same suffix detection issue as the `js/redos` query, which can cause false positives.
 * It also doesn't find all transitions in the product automaton, which can cause false negatives.
 */

private import codeql.ruby.regexp.RegExpTreeView::RegexTreeView as TreeView
// SuperlinearBackTracking should be used directly from the shared pack, and not from this file.
deprecated private import codeql.regex.nfa.SuperlinearBackTracking::Make<TreeView> as Dep
import Dep
