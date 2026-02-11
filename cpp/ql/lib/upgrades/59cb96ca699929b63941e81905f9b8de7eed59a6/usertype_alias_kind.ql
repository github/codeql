class UserType extends @usertype {
  string toString() { none() }
}

bindingset[kind]
int getKind(int kind) {
  kind = 5 and result = 0
  or
  kind = 14 and result = 1
}

from UserType usertype, int kind
where usertypes(usertype, _, kind)
select usertype, getKind(kind)
