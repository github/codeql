import python

/** A parameter list */
class ParameterList extends @py_parameter_list {

    Function getParent() {
        py_parameter_lists(this, result)
    }

    /** Gets a parameter */
    Parameter getAnItem() {
        /* Item can be a Name or a Tuple, both of which are expressions */
        py_exprs(result, _, this, _)
    }

    /** Gets the nth parameter */
    Parameter getItem(int index) {
        /* Item can be a Name or a Tuple, both of which are expressions */
        py_exprs(result, _, this, index)
    }

    string toString() {
        result = "ParameterList"
    }
}

/** A list of Comprehensions (for generating parts of a set, list or dictionary comprehension) */
class ComprehensionList extends ComprehensionList_ {

}

/** A list of expressions */
class ExprList extends ExprList_ {

}


library class DictItemList extends DictItemList_ {

}

library class DictItemListParent extends DictItemListParent_ {

}

/** A list of strings (the primitive type string not Bytes or Unicode) */
class StringList extends StringList_ {

}

/** A list of aliases in an import statement */
class AliasList extends AliasList_ {

}

