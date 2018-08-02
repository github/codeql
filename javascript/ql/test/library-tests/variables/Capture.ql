import javascript

from LocalVariable var
where var.isCaptured()
select var.getADeclaration(), var.getName() + " is captured"
