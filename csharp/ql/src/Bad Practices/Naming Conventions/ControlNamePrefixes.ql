/**
 * @name ASP.NET control name prefixes
 * @description Including standard prefixes in the field names of
 *              ASP.NET Web / HTML controls makes code easier to understand.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id cs/web/unprefixed-control-name
 * @tags maintainability
 */

import csharp

string prefix(string qualifier, string typename) {
  qualifier = "System.Web.UI.WebControls" and
  (
    typename = "Label" and result = "lbl"
    or
    typename = "TextBox" and result = "txt"
    or
    typename = ["Button", "LinkButton"] and result = "btn"
    or
    typename = "ImageButton" and result = "ibtn"
    or
    typename = "Hyperlink" and result = "hpl"
    or
    typename = "DropDownList" and result = "cmb"
    or
    typename = "ListBox" and result = "lst"
    or
    typename = "Datagrid" and result = "dgr"
    or
    typename = "Datalist" and result = "dtl"
    or
    typename = "Repeater" and result = "rpt"
    or
    typename = "CheckBox" and result = "chk"
    or
    typename = "CheckBoxList" and result = "chklst"
    or
    typename = "RadioButtonList" and result = "radlst"
    or
    typename = "RadioButton" and result = "rad"
    or
    typename = "Image" and result = "img"
    or
    typename = "Panel" and result = "pnl"
    or
    typename = "PlaceHolder" and result = "plh"
    or
    typename = "Calendar" and result = "cal"
    or
    typename = "AdRotator" and result = "adr"
    or
    typename = "Table" and result = "tbl"
    or
    typename = "RequiredFieldValidator" and result = "rfv"
    or
    typename = "CompareValidator" and result = "cmv"
    or
    typename = "RegularExpressionValidator" and result = "rev"
    or
    typename = "CustomValidator" and result = "csv"
    or
    typename = "ValidationSummary" and result = "vsm"
    or
    typename = "XML" and result = "xml"
    or
    typename = "Literal" and result = "lit"
    or
    typename = "Form" and result = "frm"
    or
    typename = "Frame" and result = "fra"
    or
    typename = "CrystalReportViewer" and result = "crvr"
  )
  or
  qualifier = "System.Web.UI.HtmlControls" and
  (
    typename = "TextArea" and result = "txa"
    or
    typename = "FileField" and result = "fle"
    or
    typename = "PasswordField" and result = "pwd"
    or
    typename = "Hidden" and result = "hdn"
    or
    typename = "Table" and result = "tbl"
    or
    typename = "FlowLayoutPanel" and result = "flp"
    or
    typename = "GridLayoutPanel" and result = "glp"
    or
    typename = "HorizontalRule" and result = "hr"
  )
}

from Field f, RefType t, string name, string prefix, string qualifier, string type
where
  f.getType() = t and
  f.getName() = name and
  t.hasFullyQualifiedName(qualifier, type) and
  prefix = prefix(qualifier, type) and
  not name.matches(prefix + "%")
select f, "This field should have the prefix '" + prefix + "' to match its types."
