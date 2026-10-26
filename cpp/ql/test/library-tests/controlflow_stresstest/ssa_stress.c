// This is a stress test to make sure that SSA can handle large basic blocks (see ODASA-5774).
int ssa_stress() {
  int ret = 0;

  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  // 0100

  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  // 0200

  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  // 0300

  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  // 0400

  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  // 0500

  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  // 0600

  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  // 0700

  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  // 0800

  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  // 0900

  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  // 1000

  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  // 1100

  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  // 1200

  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  // 1300

  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  // 1400

  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  // 1500

  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  // 1600

  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  // 1700

  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  // 1800

  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  // 1900

  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  // 2000

  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  // 2100

  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  // 2200

  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  // 2300

  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  // 2400

  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  ret += 0; ret += 1; ret += 2; ret += 3; ret += 4; ret += 5; ret += 6; ret += 7; ret += 8; ret += 9;
  // 2500

  return ret;
}
