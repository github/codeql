import csharp

from TypeParameter tp
where tp.getConstraints().hasUnmanagedTypeConstraint() and tp.fromSource()
select tp, "This type parameter is unmanaged."
