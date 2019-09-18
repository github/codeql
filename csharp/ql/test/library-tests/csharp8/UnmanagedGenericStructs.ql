import csharp

from TypeParameter tp
where tp.getConstraints().hasUnmanagedTypeConstraint()
select tp, "This type parameter is unmanaged."
