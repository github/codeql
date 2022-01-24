import csharp

select any(Modifiable m | m.isUnsafe() and m.fromSource())
