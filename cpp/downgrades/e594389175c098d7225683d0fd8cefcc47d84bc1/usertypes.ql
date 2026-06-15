class UserType extends @usertype {
  string toString() { none() }
}

int getTyperefKind(UserType usertype) {
  usertype_alias_kind(usertype, 0) and
  result = 5
  or
  usertype_alias_kind(usertype, 1) and
  result = 14
}

bindingset[kind]
int getKind(UserType usertype, int kind) {
  if kind = 18 then result = getTyperefKind(usertype) else result = kind
}

from UserType usertype, string name, int kind
where usertypes(usertype, name, kind)
select usertype, name, getKind(usertype, kind)
