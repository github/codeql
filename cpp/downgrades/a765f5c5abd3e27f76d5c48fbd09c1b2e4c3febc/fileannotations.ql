class File extends @file {
  string toString() { none() }
}

from File id, int kind, string name, string value
where fileannotations(id, _, kind, name, value)
select id, kind, name, value
