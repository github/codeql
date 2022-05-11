class TopLevel extends @toplevel {
  string toString() { none() }
}

from TopLevel tl
where isModule(tl) and not isNodejs(tl)
select tl
