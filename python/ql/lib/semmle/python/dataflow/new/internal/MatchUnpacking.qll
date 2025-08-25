/**
 * There are a number of patterns available for the match statement.
 * Each one transfers data and content differently to its parts.
 *
 * Furthermore, given a successful match, we can infer some data about
 * the subject. Consider the example:
 * ```python
 * match choice:
 *   case 'Y':
 *     ...body
 * ```
 * Inside `body`, we know that `choice` has the value `'Y'`.
 *
 * A similar thing happens with the "as pattern". Consider the example:
 * ```python
 * match choice:
 *  case ('y'|'Y') as c:
 *   ...body
 * ```
 * By the binding rules, there is data flow from `choice` to `c`. But we
 * can infer the value of `c` to be either `'y'` or `'Y'` if the match succeeds.
 *
 * We will treat such inferences separately as guards. First we will model the data flow
 * stemming from the bindings and the matching of shape. Below, 'subject' is not necessarily the
 * top-level subject of the match, but rather the part recursively matched by the current pattern.
 * For instance, in the example:
 * ```python
 * match command:
 *  case ('quit' as c) | ('go', ('up'|'down') as c):
 *   ...body
 * ```
 * `command` is the subject of first the as-pattern, while the second component of `command`
 * is the subject of the second as-pattern. As such, 'subject' refers to the pattern under evaluation.
 *
 * - as pattern: subject flows to alias as well as to the interior pattern
 * - or pattern: subject flows to each alternative
 * - literal pattern: flow from the literal to the pattern, to add information
 * - capture pattern: subject flows to the variable
 * - wildcard pattern: no flow
 * - value pattern: flow from the value to the pattern, to add information
 * - sequence pattern: each element reads from subject at the associated index
 * - star pattern: subject flows to the variable, possibly via a conversion
 * - mapping pattern: each value reads from subject at the associated key
 * - double star pattern: subject flows to the variable, possibly via a conversion
 * - key-value pattern: the value reads from the subject at the key (see mapping pattern)
 * - class pattern: all keywords read the appropriate attribute from the subject
 * - keyword pattern: the appropriate attribute is read from the subject (see class pattern)
 *
 * Inside the class pattern, we also find positional arguments. They are converted to
 * keyword arguments using the `__match_args__` attribute on the class. We do not
 * currently model this.
 */

private import python
private import DataFlowPublic

/**
 * Holds when there is flow from the subject `nodeFrom` to the (top-level) pattern `nodeTo` of a `match` statement.
 *
 * The subject of a match flows to each top-level pattern
 * (a pattern directly under a `case` statement).
 *
 * We could consider a model closer to use-use-flow, where the subject
 * only flows to the first top-level pattern and from there to the
 * following ones.
 */
predicate matchSubjectFlowStep(Node nodeFrom, Node nodeTo) {
  exists(MatchStmt match, Expr subject, Pattern target |
    subject = match.getSubject() and
    target = match.getCase(_).(Case).getPattern()
  |
    nodeFrom.(CfgNode).getNode().getNode() = subject and
    nodeTo.(CfgNode).getNode().getNode() = target
  )
}

/**
 * as pattern: subject flows to alias as well as to the interior pattern
 * syntax (toplevel): `case pattern as alias:`
 */
predicate matchAsFlowStep(Node nodeFrom, Node nodeTo) {
  exists(MatchAsPattern subject, Name alias | alias = subject.getAlias() |
    // We make the subject flow to the interior pattern via the alias.
    // That way, information can propagate from the interior pattern to the alias.
    //
    // the subject flows to the interior pattern
    nodeFrom.(CfgNode).getNode().getNode() = subject and
    nodeTo.(CfgNode).getNode().getNode() = subject.getPattern()
    or
    // the interior pattern flows to the alias
    nodeFrom.(CfgNode).getNode().getNode() = subject.getPattern() and
    exists(PatternAliasDefinition pad | pad.getDefiningNode().getNode() = alias |
      nodeTo.(CfgNode).getNode() = pad.getDefiningNode()
    )
  )
}

/**
 * or pattern: subject flows to each alternative
 * syntax (toplevel): `case alt1 | alt2:`
 */
predicate matchOrFlowStep(Node nodeFrom, Node nodeTo) {
  exists(MatchOrPattern subject, Pattern pattern | pattern = subject.getAPattern() |
    nodeFrom.(CfgNode).getNode().getNode() = subject and
    nodeTo.(CfgNode).getNode().getNode() = pattern
  )
}

/**
 * literal pattern: flow from the literal to the pattern, to add information
 * syntax (toplevel): `case literal:`
 */
predicate matchLiteralFlowStep(Node nodeFrom, Node nodeTo) {
  exists(MatchLiteralPattern pattern, Expr literal | literal = pattern.getLiteral() |
    nodeFrom.(CfgNode).getNode().getNode() = literal and
    nodeTo.(CfgNode).getNode().getNode() = pattern
  )
}

/**
 * capture pattern: subject flows to the variable
 * syntax (toplevel): `case var:`
 */
predicate matchCaptureFlowStep(Node nodeFrom, Node nodeTo) {
  exists(MatchCapturePattern capture, Name var | capture.getVariable() = var |
    nodeFrom.(CfgNode).getNode().getNode() = capture and
    exists(PatternCaptureDefinition pcd | pcd.getDefiningNode().getNode() = var |
      nodeTo.(CfgNode).getNode() = pcd.getDefiningNode()
    )
  )
}

/**
 * value pattern: flow from the value to the pattern, to add information
 * syntax (toplevel): `case Dotted.value:`
 */
predicate matchValueFlowStep(Node nodeFrom, Node nodeTo) {
  exists(MatchValuePattern pattern, Expr value | value = pattern.getValue() |
    nodeFrom.(CfgNode).getNode().getNode() = value and
    nodeTo.(CfgNode).getNode().getNode() = pattern
  )
}

/**
 * sequence pattern: each element reads from subject at the associated index
 * syntax (toplevel): `case [a, b]:`
 */
predicate matchSequenceReadStep(Node nodeFrom, Content c, Node nodeTo) {
  exists(MatchSequencePattern subject, int index, Pattern element |
    element = subject.getPattern(index)
  |
    nodeFrom.(CfgNode).getNode().getNode() = subject and
    nodeTo.(CfgNode).getNode().getNode() = element and
    (
      // tuple content
      c.(TupleElementContent).getIndex() = index
      or
      // list content
      c instanceof ListElementContent
      // set content is excluded from sequence patterns,
      // see https://www.python.org/dev/peps/pep-0635/#sequence-patterns
    )
  )
}

/**
 * star pattern: subject flows to the variable, possibly via a conversion
 * syntax (toplevel): `case *var:`
 *
 * We decompose this flow into a read step and a store step. The read step
 * reads both tuple and list content, the store step only stores list content.
 * This way, we convert all content to list content.
 *
 * This is the read step.
 */
predicate matchStarReadStep(Node nodeFrom, Content c, Node nodeTo) {
  exists(MatchSequencePattern subject, int index, MatchStarPattern star |
    star = subject.getPattern(index)
  |
    nodeFrom.(CfgNode).getNode().getNode() = subject and
    nodeTo = TStarPatternElementNode(star) and
    (
      // tuple content
      c.(TupleElementContent).getIndex() >= index
      or
      // list content
      c instanceof ListElementContent
      // set content is excluded from sequence patterns,
      // see https://www.python.org/dev/peps/pep-0635/#sequence-patterns
    )
  )
}

/**
 * star pattern: subject flows to the variable, possibly via a conversion
 * syntax (toplevel): `case *var:`
 *
 * We decompose this flow into a read step and a store step. The read step
 * reads both tuple and list content, the store step only stores list content.
 * This way, we convert all content to list content.
 *
 * This is the store step.
 */
predicate matchStarStoreStep(Node nodeFrom, Content c, Node nodeTo) {
  exists(MatchStarPattern star |
    nodeFrom = TStarPatternElementNode(star) and
    nodeTo.(CfgNode).getNode().getNode() = star.getTarget() and
    c instanceof ListElementContent
  )
}

/**
 * mapping pattern: each value reads from subject at the associated key
 * syntax (toplevel): `case {"color": c, "height": x}:`
 */
predicate matchMappingReadStep(Node nodeFrom, Content c, Node nodeTo) {
  exists(
    MatchMappingPattern subject, MatchKeyValuePattern keyValue, MatchLiteralPattern key,
    Pattern value
  |
    keyValue = subject.getAMapping() and
    key = keyValue.getKey() and
    value = keyValue.getValue()
  |
    nodeFrom.(CfgNode).getNode().getNode() = subject and
    nodeTo.(CfgNode).getNode().getNode() = value and
    c.(DictionaryElementContent).getKey() = key.getLiteral().(StringLiteral).getText()
  )
}

/**
 * double star pattern: subject flows to the variable, possibly via a conversion
 * syntax (toplevel): `case {**var}:`
 *
 * Dictionary content flows to the double star, but all mentioned keys in the
 * mapping pattern should be cleared.
 */
predicate matchMappingFlowStep(Node nodeFrom, Node nodeTo) {
  exists(MatchMappingPattern subject, MatchDoubleStarPattern dstar | dstar = subject.getAMapping() |
    nodeFrom.(CfgNode).getNode().getNode() = subject and
    nodeTo.(CfgNode).getNode().getNode() = dstar.getTarget()
  )
}

/**
 * Bindings that are mentioned in a mapping pattern will not be available
 * to a double star pattern in the same mapping pattern.
 */
predicate matchMappingClearStep(Node n, Content c) {
  exists(
    MatchMappingPattern subject, MatchKeyValuePattern keyValue, MatchLiteralPattern key,
    MatchDoubleStarPattern dstar
  |
    keyValue = subject.getAMapping() and
    key = keyValue.getKey() and
    dstar = subject.getAMapping()
  |
    n.(CfgNode).getNode().getNode() = dstar.getTarget() and
    c.(DictionaryElementContent).getKey() = key.getLiteral().(StringLiteral).getText()
  )
}

/**
 * class pattern: all keywords read the appropriate attribute from the subject
 * syntax (toplevel): `case ClassName(attr = val):`
 */
predicate matchClassReadStep(Node nodeFrom, Content c, Node nodeTo) {
  exists(MatchClassPattern subject, MatchKeywordPattern keyword, Name attr, Pattern value |
    keyword = subject.getKeyword(_) and
    attr = keyword.getAttribute() and
    value = keyword.getValue()
  |
    nodeFrom.(CfgNode).getNode().getNode() = subject and
    nodeTo.(CfgNode).getNode().getNode() = value and
    c.(AttributeContent).getAttribute() = attr.getId()
  )
}

/** All flow steps associated with match. */
predicate matchFlowStep(Node nodeFrom, Node nodeTo) {
  matchSubjectFlowStep(nodeFrom, nodeTo)
  or
  matchAsFlowStep(nodeFrom, nodeTo)
  or
  matchOrFlowStep(nodeFrom, nodeTo)
  or
  matchLiteralFlowStep(nodeFrom, nodeTo)
  or
  matchCaptureFlowStep(nodeFrom, nodeTo)
  or
  matchValueFlowStep(nodeFrom, nodeTo)
  or
  matchMappingFlowStep(nodeFrom, nodeTo)
}

/** All read steps associated with match. */
predicate matchReadStep(Node nodeFrom, Content c, Node nodeTo) {
  matchClassReadStep(nodeFrom, c, nodeTo)
  or
  matchSequenceReadStep(nodeFrom, c, nodeTo)
  or
  matchMappingReadStep(nodeFrom, c, nodeTo)
  or
  matchStarReadStep(nodeFrom, c, nodeTo)
}

/** All store steps associated with match. */
predicate matchStoreStep(Node nodeFrom, Content c, Node nodeTo) {
  matchStarStoreStep(nodeFrom, c, nodeTo)
}

/**
 * All clear steps associated with match
 */
predicate matchClearStep(Node n, Content c) { matchMappingClearStep(n, c) }
