import java.io.*;

public class Large {
  /*
   * SSA stress test designed to catch O(n^3) implementations.
   * There is one method with a single basic block with many SSA redefinitions
   * and one method with many basic blocks each containing SSA redefinitions.
   *
   * A count of 800 in each seems good for interactive development and a count of
   * 2500 seems adequate to yield timeouts in case of O(n^3) implementations.
   */

  public String singleBlock() {
    String ret = "A";

    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    // 100

    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    // 200

    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    // 300

    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    // 400

    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    // 500

    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    // 600

    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    // 700

    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    // 800

    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    // 900

    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    // 1000

    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    // 1100

    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    // 1200

    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    // 1300

    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    // 1400

    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    // 1500

    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    // 1600

    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    // 1700

    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    // 1800

    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    // 1900

    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    // 2000

    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    // 2100

    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    // 2200

    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    // 2300

    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    // 2400

    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    ret += "0"; ret += "1"; ret += "2"; ret += "3"; ret += "4"; ret += "5"; ret += "6"; ret += "7"; ret += "8"; ret += "9";
    // 2500

    return ret;
  }

  public void f() throws IOException {
  }

  public String manyBlocks() throws IOException {
    String ret = "B";

    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    // 100

    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    // 200

    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    // 300

    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    // 400

    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    // 500

    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    // 600

    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    // 700

    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    // 800

    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    // 900

    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    // 1000

    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    // 1100

    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    // 1200

    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    // 1300

    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    // 1400

    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    // 1500

    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    // 1600

    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    // 1700

    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    // 1800

    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    // 1900

    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    // 2000

    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    // 2100

    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    // 2200

    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    // 2300

    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    // 2400

    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    ret += "0"; f(); ret += "1"; f(); ret += "2"; f(); ret += "3"; f(); ret += "4"; f(); ret += "5"; f(); ret += "6"; f(); ret += "7"; f(); ret += "8"; f(); ret += "9"; f();
    // 2500

    return ret;
  }
}
