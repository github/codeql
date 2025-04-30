class UserType extends @usertype {
  string toString() { none() }
}

bindingset[kind]
int getKind(int kind) {
  if kind in [10, 11, 12]
  then result = 0
  else
    if kind = 6
    then result = 16
    else result = kind
}

from UserType usertype, string name, int kind
where usertypes(usertype, name, kind)
select usertype, name, getKind(kind)
