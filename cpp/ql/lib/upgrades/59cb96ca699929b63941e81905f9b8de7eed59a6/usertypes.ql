class UserType extends @usertype {
  string toString() { none() }
}

bindingset[kind]
int getKind(int kind) { if kind = [5, 14] then result = 18 else result = kind }

from UserType usertype, string name, int kind
where usertypes(usertype, name, kind)
select usertype, name, getKind(kind)
