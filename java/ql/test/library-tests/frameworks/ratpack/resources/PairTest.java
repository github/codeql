import ratpack.exec.Promise;
import ratpack.exec.Result;
import ratpack.func.Action;
import ratpack.func.Pair;


public class PairTest {
    
    void sink(Object o) {}

    String taint() {
        return null;
    }

    void test1() {
        Pair<String, String> pair = Pair.of("safe", "safe");
        sink(pair.left); // no taint flow
        sink(pair.left()); // no taint flow
        sink(pair.getLeft()); // no taint flow
        sink(pair.right); // no taint flow
        sink(pair.right()); // no taint flow
        sink(pair.getRight()); // no taint flow
        Pair<String, String> updatedLeftPair = pair.left(taint());
        sink(updatedLeftPair.left); //$hasTaintFlow
        sink(updatedLeftPair.left()); //$hasTaintFlow
        sink(updatedLeftPair.getLeft()); //$hasTaintFlow
        sink(updatedLeftPair.right); // no taint flow
        sink(updatedLeftPair.right()); // no taint flow
        sink(updatedLeftPair.getRight()); // no taint flow
        Pair<String, String> updatedRightPair = pair.right(taint());
        sink(updatedRightPair.left); // no taint flow
        sink(updatedRightPair.left()); // no taint flow
        sink(updatedRightPair.getLeft()); // no taint flow
        sink(updatedRightPair.right); //$hasTaintFlow
        sink(updatedRightPair.right()); //$hasTaintFlow
        sink(updatedRightPair.getRight()); //$hasTaintFlow
        Pair<String, String> updatedBothPair = pair.left(taint()).right(taint());
        sink(updatedBothPair.left); //$hasTaintFlow
        sink(updatedBothPair.left()); //$hasTaintFlow
        sink(updatedBothPair.getLeft()); //$hasTaintFlow
        sink(updatedBothPair.right); //$hasTaintFlow
        sink(updatedBothPair.right()); //$hasTaintFlow
        sink(updatedBothPair.getRight()); //$hasTaintFlow
    }

    void test2() {
        Pair<String, String> pair = Pair.of(taint(), taint());
        sink(pair.left); //$hasTaintFlow
        sink(pair.left()); //$hasTaintFlow
        sink(pair.getLeft()); //$hasTaintFlow
        sink(pair.right); //$hasTaintFlow
        sink(pair.right()); //$hasTaintFlow
        sink(pair.getRight()); //$hasTaintFlow
        Pair<String, Pair<String, String>> pushedLeftPair = pair.pushLeft("safe");
        sink(pushedLeftPair.left()); // no taint flow
        sink(pushedLeftPair.right().left()); //$hasTaintFlow
        sink(pushedLeftPair.right().right()); //$hasTaintFlow
        Pair<Pair<String, String>, String> pushedRightPair = pair.pushRight("safe");
        sink(pushedRightPair.left().left()); //$hasTaintFlow
        sink(pushedRightPair.left().right()); //$hasTaintFlow
        sink(pushedRightPair.right()); // no taint flow
    }

    void test3() {
        Pair<String, String> pair = Pair.of("safe", "safe");
        sink(pair.left); // no taint flow
        sink(pair.left()); // no taint flow
        sink(pair.getLeft()); // no taint flow
        sink(pair.right); // no taint flow
        sink(pair.right()); // no taint flow
        sink(pair.getRight()); // no taint flow
        Pair<String, Pair<String, String>> pushedLeftPair = pair.pushLeft(taint());
        sink(pushedLeftPair.left()); //$hasTaintFlow
        sink(pushedLeftPair.right().left()); // no taint flow
        sink(pushedLeftPair.right().right()); // no taint flow
        Pair<Pair<String, String>, String> pushedRightPair = pair.pushRight(taint());
        sink(pushedRightPair.left().left()); // no taint flow
        sink(pushedRightPair.left().right()); // no taint flow
        sink(pushedRightPair.right()); //$hasTaintFlow
    }

    void test4() {
        Pair<String, String> pair = Pair.of(taint(), taint());
        sink(pair.left()); //$hasTaintFlow
        sink(pair.right()); //$hasTaintFlow
        Pair<Pair<String, String>, String> nestLeftPair = pair.nestLeft("safe");
        sink(nestLeftPair.left().left()); // no taint flow
        sink(nestLeftPair.left().right()); //$hasTaintFlow
        sink(nestLeftPair.right()); //$hasTaintFlow
        Pair<String, Pair<String, String>> nestRightPair = pair.nestRight("safe");
        sink(nestRightPair.left()); //$hasTaintFlow
        sink(nestRightPair.right().left()); // no taint flow
        sink(nestRightPair.right().right()); //$hasTaintFlow
    }

    void test5() {
        Pair<String, String> pair = Pair.of(taint(), "safe");
        sink(pair.left()); //$hasTaintFlow
        sink(pair.right()); // no taint flow
        Pair<Pair<String, String>, String> nestLeftPair = pair.nestLeft("safe");
        sink(nestLeftPair.left().left()); // no taint flow
        sink(nestLeftPair.left().right()); //$hasTaintFlow
        sink(nestLeftPair.right()); // no taint flow
        Pair<String, Pair<String, String>> nestRightPair = pair.nestRight("safe");
        sink(nestRightPair.left()); //$hasTaintFlow
        sink(nestRightPair.right().left()); // no taint flow
        sink(nestRightPair.right().right()); // no taint flow
    }

    void test6() {
        Pair<String, String> pair = Pair.of("safe", taint());
        sink(pair.left()); // no taint flow
        sink(pair.right()); //$hasTaintFlow
        Pair<Pair<String, String>, String> nestLeftPair = pair.nestLeft("safe");
        sink(nestLeftPair.left().left()); // no taint flow
        sink(nestLeftPair.left().right()); // no taint flow
        sink(nestLeftPair.right()); //$hasTaintFlow
        Pair<String, Pair<String, String>> nestRightPair = pair.nestRight("safe");
        sink(nestRightPair.left()); // no taint flow
        sink(nestRightPair.right().left()); // no taint flow
        sink(nestRightPair.right().right()); //$hasTaintFlow
    }

    void test7() {
        Pair<String, String> pair = Pair.of("safe", "safe");
        sink(pair.left()); // no taint flow
        sink(pair.right()); // no taint flow
        Pair<Pair<String, String>, String> nestLeftPair = pair.nestLeft(taint());
        sink(nestLeftPair.left().left()); // $hasTaintFlow
        sink(nestLeftPair.left().right()); // no taint flow
        sink(nestLeftPair.right()); // no taint flow
        Pair<String, Pair<String, String>> nestRightPair = pair.nestRight(taint());
        sink(nestRightPair.left()); // no taint flow
        sink(nestRightPair.right().left()); // $hasTaintFlow
        sink(nestRightPair.right().right()); // no taint flow
    }

    void test8() throws Exception {
        Pair<String, String> pair = Pair.of("safe", "safe");
        Pair<String, String> taintLeft = pair.mapLeft(left -> {
            sink(left); // no taint flow
            return taint();
        });
        sink(taintLeft.left()); //$hasTaintFlow
        sink(taintLeft.right()); // no taint flow
    }

    void test9() throws Exception  {
        Pair<String, String> pair = Pair.of("safe", "safe");
        Pair<String, String> taintRight = pair.mapRight(left -> {
            sink(left); // no taint flow
            return taint();
        });
        sink(taintRight.left()); // no taint flow
        sink(taintRight.right()); //$hasTaintFlow
    }

    void test10() throws Exception {
        Pair<String, String> pair = Pair.of(taint(), taint());
        Pair<String, String> taintLeft = pair.mapLeft(left -> {
            sink(left); //$hasTaintFlow
            return "safe";
        });
        sink(taintLeft.left()); // no taint flow
        sink(taintLeft.right()); //$hasTaintFlow
    }

    void test11() throws Exception {
        Pair<String, String> pair = Pair.of(taint(), taint());
        Pair<String, String> taintRight = pair.mapRight(right -> {
            sink(right); //$hasTaintFlow
            return "safe";
        });
        sink(taintRight.left()); //$hasTaintFlow
        sink(taintRight.right()); // no taint flow
    }

    void test12() throws Exception {
        Pair<String, String> pair = Pair.of(taint(), taint());
        String safe = pair.map(p -> {
            sink(p.left()); //$hasTaintFlow
            sink(p.right()); //$hasTaintFlow
            return "safe";
        });
        sink(safe); // no taint flow
        String unsafe = pair.map(p -> {
            sink(p.left()); //$hasTaintFlow
            sink(p.right()); //$hasTaintFlow
            return taint();
        });
        sink(unsafe); //$hasTaintFlow
    }

    void test13() {
        Promise
            .value(taint())
            .left(Promise.value("safe"))
            .then(pair -> {
                sink(pair.left()); // no taint flow
                sink(pair.right()); //$hasTaintFlow
            });
        Promise
            .value(taint())
            .right(Promise.value("safe"))
            .then(pair -> {
                sink(pair.left()); //$hasTaintFlow
                sink(pair.right()); // no taint flow
            });
        Promise
            .value("safe")
            .left(Promise.value(taint()))
            .then(pair -> {
                sink(pair.left()); //$hasTaintFlow
                sink(pair.right()); // no taint flow
            });
        Promise
            .value("safe")
            .right(Promise.value(taint()))
            .then(pair -> {
                sink(pair.left()); // no taint flow
                sink(pair.right()); //$hasTaintFlow
            });
    }

    void test14() {
        Promise
            .value(taint())
            .left(value -> {
                sink(value); //$hasTaintFlow
                return "safe";
            })
            .then(pair -> {
                sink(pair.left()); // no taint flow
                sink(pair.right()); //$hasTaintFlow
            });
        Promise
            .value(taint())
            .right(value -> {
                sink(value); //$hasTaintFlow
                return "safe";
            })
            .then(pair -> {
                sink(pair.left()); //$hasTaintFlow
                sink(pair.right()); // no taint flow
            });
        Promise
            .value("safe")
            .left(value -> {
                sink(value); // no taint flow
                return taint();
            })
            .then(pair -> {
                sink(pair.left()); //$hasTaintFlow
                sink(pair.right()); // no taint flow
            });
        Promise
            .value("safe")
            .right(value -> {
                sink(value); // no taint flow
                return taint();
            })
            .then(pair -> {
                sink(pair.left()); // no taint flow
                sink(pair.right()); //$hasTaintFlow
            });
    }

    void test15() {
        Promise
            .value(taint())
            .flatLeft(value -> {
                sink(value); //$hasTaintFlow
                return Promise.value("safe");
            })
            .then(pair -> {
                sink(pair.left()); // no taint flow
                sink(pair.right()); //$hasTaintFlow
            });
        Promise
            .value(taint())
            .flatRight(value -> {
                sink(value); //$hasTaintFlow
                return Promise.value("safe");
            })
            .then(pair -> {
                sink(pair.left()); //$hasTaintFlow
                sink(pair.right()); // no taint flow
            });
        Promise
            .value("safe")
            .flatLeft(value -> {
                return Promise.value(taint());
            })
            .then(pair -> {
                sink(pair.left()); //$hasTaintFlow
                sink(pair.right()); // no taint flow
            });
        Promise
            .value("safe")
            .flatRight(value -> {
                return Promise.value(taint());
            })
            .then(pair -> {
                sink(pair.left()); // no taint flow
                sink(pair.right()); //$hasTaintFlow
            });
    }
}
