import javascript

from FieldDeclaration f, boolean ambient
where if f.isAmbient() then ambient = true else ambient = false
select f, ambient
