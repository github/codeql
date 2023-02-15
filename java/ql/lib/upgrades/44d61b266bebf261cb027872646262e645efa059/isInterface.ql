class Interface extends @interface {
  string toString() { result = "interface" }
}

from Interface i
select i
