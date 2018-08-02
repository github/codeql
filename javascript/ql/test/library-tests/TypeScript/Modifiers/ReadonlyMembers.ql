import javascript

from FieldDeclaration field
where field.isReadonly()
select field.getStartLine().getText()
