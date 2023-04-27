/**
 * @name Alert suppression
 * @description Generates information about alert suppressions.
 * @kind alert-suppression
 * @id go/alert-suppression
 */

private import codeql.util.suppression.AlertSuppression as AS
private import semmle.go.Comments as G

class SingleLineComment extends G::Comment {
  SingleLineComment() {
    // suppression comments must be single-line
    not this.getText().matches("%\n%")
  }
}

import AS::Make<G::Locatable, SingleLineComment>
