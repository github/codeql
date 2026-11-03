bool cond();

void multiple_forward_and_backward_goto() { // $ Alert
backward_one:
  if (cond()) goto forward_one;
backward_two:
  if (cond()) goto forward_two;
forward_one:
  if (cond()) goto backward_one;
forward_two:
  if (cond()) goto backward_two;
}

void only_forward_goto() {
  if (cond()) goto end;

  // ...

  if (cond()) goto end;

  // ...

end:
  // ...
}
