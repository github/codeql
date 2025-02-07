switch (a) {
  case 0:
  case 1:
  case2: // $ TODO-SPURIOUS: Alert
    f();
    break;
  default:
    g();
}

switch (a) {
case 0:
case 1:
  case2:
  f();
  break;
default:
  g();
}
