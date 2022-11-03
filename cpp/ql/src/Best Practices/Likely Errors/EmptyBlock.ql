/**
 * @name Empty branch of conditional
 * @description An empty block after a conditional can be a sign of an omission
 *              and can decrease maintainability of the code. Such blocks
 *              should contain an explanatory comment to aid future
 *              maintainers.
 * @kind problem
 * @problem.severity recommendation
 * @precision very-high
 * @id cpp/empty-block
 * @tags reliability
 *       readability
 */

import cpp

predicate emptyBlock(ControlStructure s, BlockStmt b) {
  b = s.getAChild() and
  not exists(b.getAChild()) and
  not b.isInMacroExpansion() and
  not s instanceof Loop
}

class AffectedFile extends File {
  AffectedFile() {
    exists(BlockStmt b |
      emptyBlock(_, b) and
      this = b.getFile()
    )
  }
}

/**
 * A block, or an element we might find textually within a block that is
 * not a child of it in the AST.
 */
class BlockOrNonChild extends Element {
  BlockOrNonChild() {
    (
      this instanceof BlockStmt
      or
      this instanceof Comment
      or
      this instanceof PreprocessorDirective
      or
      this instanceof MacroInvocation
    ) and
    this.getFile() instanceof AffectedFile
  }

  private int getNonContiguousStartRankIn(AffectedFile file) {
    // When using `rank` with `order by`, the ranks may not be contiguous.
    this =
      rank[result](BlockOrNonChild boc, int startLine, int startCol |
        boc.getLocation().hasLocationInfo(file.getAbsolutePath(), startLine, startCol, _, _)
      |
        boc order by startLine, startCol
      )
  }

  int getStartRankIn(AffectedFile file) {
    this.getNonContiguousStartRankIn(file) =
      rank[result](int rnk |
        exists(BlockOrNonChild boc | boc.getNonContiguousStartRankIn(file) = rnk)
      )
  }

  int getNonContiguousEndRankIn(AffectedFile file) {
    this =
      rank[result](BlockOrNonChild boc, int endLine, int endCol |
        boc.getLocation().hasLocationInfo(file.getAbsolutePath(), _, _, endLine, endCol)
      |
        boc order by endLine, endCol
      )
  }
}

/**
 * A block that contains a non-child element.
 */
predicate emptyBlockContainsNonchild(BlockStmt b) {
  emptyBlock(_, b) and
  exists(BlockOrNonChild c, AffectedFile file |
    c.(BlockOrNonChild).getStartRankIn(file) = 1 + b.(BlockOrNonChild).getStartRankIn(file) and
    c.(BlockOrNonChild).getNonContiguousEndRankIn(file) <
      b.(BlockOrNonChild).getNonContiguousEndRankIn(file)
  )
}

/**
 * A block that is entirely on one line, which also contains a comment.  Chances
 * are the comment is intended to refer to the block.
 */
predicate lineComment(BlockStmt b) {
  emptyBlock(_, b) and
  exists(Location bLocation, File f, int line |
    bLocation = b.getLocation() and
    f = bLocation.getFile() and
    line = bLocation.getStartLine() and
    line = bLocation.getEndLine() and
    exists(Comment c, Location cLocation |
      cLocation = c.getLocation() and
      cLocation.getFile() = f and
      cLocation.getStartLine() = line
    )
  )
}

from ControlStructure s, BlockStmt eb
where
  emptyBlock(s, eb) and
  not emptyBlockContainsNonchild(eb) and
  not lineComment(eb)
select eb, "Empty block without comment"
