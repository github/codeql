import semmle.code.java.Diagnostics

from Diagnostic d
where d.getSeverity() > 2
select d, d.getGeneratedBy(), d.getSeverity(), d.getTag(), d.getMessage(),
  d.getFullMessage()
      .regexpReplaceAll("^\\[[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2} K\\] ",
        "[DATE TIME K] ")
