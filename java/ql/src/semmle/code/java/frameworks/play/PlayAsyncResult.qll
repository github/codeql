import java

/**
<<<<<<< HEAD
 * Play Framework Async Promise - Gets the Promise<Result> Generic Member/Type of (play.libs.F)
 *
 * Documentation: https://www.playframework.com/documentation/2.5.1/api/java/play/libs/F.Promise.html
=======
 * Play Framework Async Promise of Generic Result
 *
 * @description Gets the Promise<Result> Generic Type of (play.libs.F), This is async in 2.6x and below.
 * (https://www.playframework.com/documentation/2.5.1/api/java/play/libs/F.Promise.html)
>>>>>>> fa523e456f96493dcc08b819ad4bd620cca789b8
 */
class PlayAsyncResultPromise extends Member {
  PlayAsyncResultPromise() {
    exists(Class c |
      c.hasQualifiedName("play.libs", "F") and
      this = c.getAMember() and
      this.getQualifiedName() = "F.Promise<Result>"
    )
  }
}

/**
<<<<<<< HEAD
 * Play Framework Async Generic Result - Gets the CompletionStage<Result> Generic Type of (java.util.concurrent)
 *
 * Documentation: https://www.playframework.com/documentation/2.6.x/JavaAsync
=======
 * Play Framework Async Generic Result extending generic promise API called CompletionStage.
 *
 * @description Gets the CompletionStage<Result> Generic Type of (java.util.concurrent)
 * (https://www.playframework.com/documentation/2.6.x/JavaAsync)
>>>>>>> fa523e456f96493dcc08b819ad4bd620cca789b8
 */
class PlayAsyncResultCompletionStage extends Type {
  PlayAsyncResultCompletionStage() {
    this.hasName("CompletionStage<Result>") and
    this.getCompilationUnit().getPackage().hasName("java.util.concurrent")
  }
}
