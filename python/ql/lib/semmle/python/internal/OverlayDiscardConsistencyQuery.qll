/**
 * Provides consistency queries for checking that every database entity
 * that can be discarded (i.e. everything but `@py_cobject`) in an overlay
 * database is indeed discarded, by proxy of having exactly one `Discardable.getPath()`.
 */

import python
import semmle.python.Overlay

class TopWithToString instanceof @top {
  string getDbType() {
    this instanceof @py_source_element and result = "@source_element"
    or
    this instanceof @py_object and result = "@py_object"
    or
    this instanceof @py_base_var and result = "@py_base_var"
    or
    this instanceof @location and result = "@location"
    or
    this instanceof @py_line and result = "@py_line"
    or
    this instanceof @py_comment and result = "@py_comment"
    or
    this instanceof @py_expr_parent and result = "@py_expr_parent"
    or
    this instanceof @py_expr_context and result = "@py_expr_context"
    or
    this instanceof @py_operator and result = "@py_operator"
    or
    this instanceof @py_boolop and result = "@py_boolop"
    or
    this instanceof @py_cmpop and result = "@py_cmpop"
    or
    this instanceof @py_unaryop and result = "@py_unaryop"
    or
    this instanceof @py_cmpop_list and result = "@py_cmpop_list"
    or
    this instanceof @py_alias_list and result = "@py_alias_list"
    or
    this instanceof @py_StringPart_list and result = "@py_StringPart_list"
    or
    this instanceof @py_comprehension_list and result = "@py_comprehension_list"
    or
    this instanceof @py_dict_item_list and result = "@py_dict_item_list"
    or
    this instanceof @py_pattern_list and result = "@py_pattern_list"
    or
    this instanceof @py_stmt_list and result = "@py_stmt_list"
    or
    this instanceof @py_str_list and result = "@py_str_list"
    or
    this instanceof @py_type_parameter_list and result = "@py_type_parameter_list"
    or
    this instanceof @externalDefect and result = "@externalDefect"
    or
    this instanceof @externalMetric and result = "@externalMetric"
    or
    this instanceof @externalDataElement and result = "@externalDataElement"
    or
    this instanceof @duplication_or_similarity and result = "@duplication_or_similarity"
    or
    this instanceof @svnentry and result = "@svnentry"
    or
    this instanceof @xmllocatable and result = "@xmllocatable"
    or
    this instanceof @yaml_locatable and result = "@yaml_locatable"
  }

  string toString() {
    result = this.getDbType()
    or
    not exists(this.getDbType()) and
    result = "Unknown type"
  }
}

query predicate consistencyTest(TopWithToString el, string message) {
  not el instanceof Discardable and
  not el instanceof @py_cobject and // cannot be linked to a path
  not el instanceof @externalDataElement and // cannot be linked to a path
  message = "Not Discardable"
  or
  exists(Discardable d, int numPaths | d = el and numPaths = count(d.getPath()) |
    numPaths = 0 and
    message = "Discardable but no path found"
    or
    numPaths > 1 and
    message = "Discardable but multiple paths found (" + concat(d.getPath(), ", ") + ")"
  )
}
