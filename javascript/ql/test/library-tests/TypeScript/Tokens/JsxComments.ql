import javascript

from Comment c
where c.getFile().getBaseName() = "jsx.tsx"
select c, c.getText()
