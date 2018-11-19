/** 
 * In order to handle data flow and other analyses efficiently the extractor transforms various statements which perform binding in assignments.
 * These classes provide a wrapper to provide a more 'natural' interface to the syntactic elements transformed to assignments.
 */

import python


/** An assignment statement */
class AssignStmt extends Assign {

    AssignStmt() {
        not this instanceof FunctionDef and not this instanceof ClassDef
    }

    override string toString() {
        result = "AssignStmt"
    }
}
