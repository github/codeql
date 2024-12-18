import python

from SyntaxError s, string fp, int line, int col
where s.hasLocationInfo(fp, line, col, _, _)
select fp, s.toString(), line, col
