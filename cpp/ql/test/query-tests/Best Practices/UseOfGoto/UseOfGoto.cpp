void multiple_forward_and_backward_targets_one() { // $ Alert
  goto forward_one;
  goto forward_two;
forward_one:
  ;
forward_two:
  ;
backward_one:
  ;
backward_two:
  ;
  goto backward_one;
  goto backward_two;
}

void multiple_forward_and_backward_targets_two() { // $ Alert
  goto next_one;
  goto next_two;
next_one:
  ;
next_two:
  ;
earlier_one:
  ;
earlier_two:
  ;
  goto earlier_one;
  goto earlier_two;
}

void one_forward_target_is_not_enough() {
  goto forward;
forward:
  ;
backward_one:
  ;
backward_two:
  ;
  goto backward_one;
  goto backward_two;
}
