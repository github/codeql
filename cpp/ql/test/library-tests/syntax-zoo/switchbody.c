// In a standard switch statement, each exit node of the conditional expression
// has an edge to the block statement of the body, and this block statement
// has an edge to each switch case.
int switch_block(int i) {
  switch (i < 0 ? -i : i) {
  case 0:
    return 1;
  default:
    return i;
  }
}

// If the body of a switch is not a compound statement then a block statement
// is synthesized by the extractor.
int switch_single(int i) {
  switch (i < 0 ? -i : i)
  case 0:
  case 1:
    return i;
  return 2;
}

// If the body of a switch statement is a compound statement OTHER than a block
// then the CFG looks very different. Each exit node of the conditional
// expression has an edge directly to each switch case, and the body of the
// switch is unreachable. Hopefully nobody writes code like this.
int switch_notblock(int i) {
  switch (i < 0 ? -i : i)
    if (1) {
      case 0:
        return 1;
      default:
        return i;
    }
}
