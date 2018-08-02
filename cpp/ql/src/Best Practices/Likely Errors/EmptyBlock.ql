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

predicate emptyBlock(ControlStructure s, Block b) {
  b = s.getAChild() and
  not exists(b.getAChild()) and
  not b.isInMacroExpansion() and
  not s instanceof Loop
}

class AffectedFile extends File {
  AffectedFile() {
    exists(Block b |
      emptyBlock(_, b) and
      this = b.getFile()
    )
  }
}

class BlockOrNonChild extends Element {
  BlockOrNonChild() {
    ( this instanceof Block
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
    this = rank[result](BlockOrNonChild boc, int startLine, int startCol |
      boc.getLocation()
         .hasLocationInfo(file.getAbsolutePath(), startLine, startCol, _, _)
    | boc
    order by startLine, startCol
    )
  }

  int getStartRankIn(AffectedFile file) {
    this.getNonContiguousStartRankIn(file) = rank[result](int rnk |
      exists(BlockOrNonChild boc | boc.getNonContiguousStartRankIn(file) = rnk)
    )
  }

  int getNonContiguousEndRankIn(AffectedFile file) {
    this = rank[result](BlockOrNonChild boc, int endLine, int endCol |
      boc.getLocation()
         .hasLocationInfo(file.getAbsolutePath(), _, _, endLine, endCol)
    | boc
    order by endLine, endCol
    )
  }
}

predicate emptyBlockContainsNonchild(Block b) {
  emptyBlock(_, b) and
  exists(BlockOrNonChild c, AffectedFile file |
    c.(BlockOrNonChild).getStartRankIn(file) =
      1 + b.(BlockOrNonChild).getStartRankIn(file) and
    c.(BlockOrNonChild).getNonContiguousEndRankIn(file) <
      b.(BlockOrNonChild).getNonContiguousEndRankIn(file)
  )
}

from ControlStructure s, Block eb
where emptyBlock(s, eb)
  and not emptyBlockContainsNonchild(eb)
select eb, "Empty block without comment"
