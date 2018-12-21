import csharp

Version getAVersion() {
  result = "1.2" or
  result = "1.2.0" or
  result = "1.2.0.0" or
  result = "1.3" or
  result = "1.3.1" or
  result = "1.3.1.2" or
  result = "1.3.1.3" or
  result = "1.3.2" or
  result = "1.4" or
  result = "2.3.1"
}

from Version v1, Version v2
where
  v1 = getAVersion() and
  v2 = getAVersion()
select v1, v2, v1.compareTo(v2)
