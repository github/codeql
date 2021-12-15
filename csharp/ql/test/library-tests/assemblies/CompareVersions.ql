import csharp

Version getAVersion() {
  result =
    ["1.2", "1.2.0", "1.2.0.0", "1.3", "1.3.1", "1.3.1.2", "1.3.1.3", "1.3.2", "1.4", "2.3.1"]
}

from Version v1, Version v2
where
  v1 = getAVersion() and
  v2 = getAVersion()
select v1, v2, v1.compareTo(v2)
