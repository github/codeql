class UserType extends @usertype {
  string toString() { none() }
}

bindingset[kind]
int getKind(int kind) { if kind in [15, 16, 17] then result = 6 else result = kind }

from UserType usertype, string name, int kind
where usertypes(usertype, name, kind)
select usertype, name, getKind(kind)
