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

string prefix(string typename) {
  typename = "System.Web.UI.WebControls.Label" and result = "lbl"
  or
  typename = "System.Web.UI.WebControls.TextBox" and result = "txt"
  or
  typename = "System.Web.UI.WebControls.Button" and result = "btn"
  or
  typename = "System.Web.UI.WebControls.LinkButton" and result = "btn"
  or
  typename = "System.Web.UI.WebControls.ImageButton" and result = "ibtn"
  or
  typename = "System.Web.UI.WebControls.Hyperlink" and result = "hpl"
  or
  typename = "System.Web.UI.WebControls.DropDownList" and result = "cmb"
  or
  typename = "System.Web.UI.WebControls.ListBox" and result = "lst"
  or
  typename = "System.Web.UI.WebControls.Datagrid" and result = "dgr"
  or
  typename = "System.Web.UI.WebControls.Datalist" and result = "dtl"
  or
  typename = "System.Web.UI.WebControls.Repeater" and result = "rpt"
  or
  typename = "System.Web.UI.WebControls.CheckBox" and result = "chk"
  or
  typename = "System.Web.UI.WebControls.CheckBoxList" and result = "chklst"
  or
  typename = "System.Web.UI.WebControls.RadioButtonList" and result = "radlst"
  or
  typename = "System.Web.UI.WebControls.RadioButton" and result = "rad"
  or
  typename = "System.Web.UI.WebControls.Image" and result = "img"
  or
  typename = "System.Web.UI.WebControls.Panel" and result = "pnl"
  or
  typename = "System.Web.UI.WebControls.PlaceHolder" and result = "plh"
  or
  typename = "System.Web.UI.WebControls.Calendar" and result = "cal"
  or
  typename = "System.Web.UI.WebControls.AdRotator" and result = "adr"
  or
  typename = "System.Web.UI.WebControls.Table" and result = "tbl"
  or
  typename = "System.Web.UI.WebControls.RequiredFieldValidator" and result = "rfv"
  or
  typename = "System.Web.UI.WebControls.CompareValidator" and result = "cmv"
  or
  typename = "System.Web.UI.WebControls.RegularExpressionValidator" and result = "rev"
  or
  typename = "System.Web.UI.WebControls.CustomValidator" and result = "csv"
  or
  typename = "System.Web.UI.WebControls.ValidationSummary" and result = "vsm"
  or
  typename = "System.Web.UI.WebControls.XML" and result = "xml"
  or
  typename = "System.Web.UI.WebControls.Literal" and result = "lit"
  or
  typename = "System.Web.UI.WebControls.Form" and result = "frm"
  or
  typename = "System.Web.UI.WebControls.Frame" and result = "fra"
  or
  typename = "System.Web.UI.WebControls.CrystalReportViewer" and result = "crvr"
  or
  typename = "System.Web.UI.HtmlControls.TextArea" and result = "txa"
  or
  typename = "System.Web.UI.HtmlControls.FileField" and result = "fle"
  or
  typename = "System.Web.UI.HtmlControls.PasswordField" and result = "pwd"
  or
  typename = "System.Web.UI.HtmlControls.Hidden" and result = "hdn"
  or
  typename = "System.Web.UI.HtmlControls.Table" and result = "tbl"
  or
  typename = "System.Web.UI.HtmlControls.FlowLayoutPanel" and result = "flp"
  or
  typename = "System.Web.UI.HtmlControls.GridLayoutPanel" and result = "glp"
  or
  typename = "System.Web.UI.HtmlControls.HorizontalRule" and result = "hr"
}

from Field f, RefType t, string name, string prefix
where
  f.getType() = t and
  f.getName() = name and
  prefix = prefix(t.getQualifiedName()) and
  not name.matches(prefix + "%")
select f, "This field should have the prefix '" + prefix + "' to match its types."
