import java

/**
 * Play Framework Async Promise of Generic Result
 *
 * @description Gets the Promise<Result> Generic Type of (play.libs.F), This is async in 2.6x and below.
 * (https://www.playframework.com/documentation/2.5.1/api/java/play/libs/F.Promise.html)
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
 * Play Framework Async Generic Result extending generic promise API called CompletionStage.
 *
 * @description Gets the CompletionStage<Result> Generic Type of (java.util.concurrent)
 * (https://www.playframework.com/documentation/2.6.x/JavaAsync)
 */
class PlayAsyncResultCompletionStage extends Type {
  PlayAsyncResultCompletionStage() {
    this.hasName("CompletionStage<Result>") and
    this.getCompilationUnit().getPackage().hasName("java.util.concurrent")
  }
}
