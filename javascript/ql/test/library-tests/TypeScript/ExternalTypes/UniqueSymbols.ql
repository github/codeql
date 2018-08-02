import javascript

from UniqueSymbolType symbol, string moduleName, string exportedName
where symbol.hasQualifiedName(moduleName, exportedName)
select symbol, moduleName, exportedName
