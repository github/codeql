import swift

from AstNode n
where n.getAPrimaryQlClass().matches("Unresolved%")
select n
