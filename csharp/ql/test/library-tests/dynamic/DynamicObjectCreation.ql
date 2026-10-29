import csharp

from DynamicObjectCreation doc, string i
where if doc.hasInitializer() then i = doc.getInitializer().toString() else i = ""
select doc, i
