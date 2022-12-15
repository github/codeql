import java
import semmle.code.java.dataflow.FlowSummary
import semmle.code.java.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
import semmle.code.java.dataflow.ExternalFlow // for paramsString
import TopJdkApis

// from SummarizedCallable sc //, FlowSummaryImpl::Public::NegativeSummarizedCallable nsc
// where
//   //   sc.asCallable().getDeclaringType().getName() = "String" and
//   //   sc.asCallable().getName() = "format" and
//   //   sc.asCallable().getQualifiedName() = "java.lang.String.format" and
//   sc.asCallable().getDeclaringType().getPackage() + "." +
//     sc.asCallable().getDeclaringType().getSourceDeclaration() + "#" + sc.asCallable().getName() +
//     paramsString(sc.asCallable()) = "java.lang.String#format(String,Object[])"
// select sc, sc.asCallable().getQualifiedName(),
//   /*
//    * sc.asCallable().paramsString(),
//    *  sc.asCallable().getSignature(), sc.asCallable().getStringSignature(),
//    *  sc.asCallable().getDeclaringType().getSourceDeclaration(),
//    */
//   sc.asCallable().getDeclaringType().getPackage() + "." +
//     sc.asCallable().getDeclaringType().getSourceDeclaration() + "#" + sc.asCallable().getName() +
//     paramsString(sc.asCallable())
// * get string representation of al modelled topjdkapis
// from TopJdkApi t, string api
// where
//   /*t.hasMadModel() and*/
//   api =
//     t.getDeclaringType().getPackage() + "." + t.getDeclaringType().getSourceDeclaration() + "#" +
//       t.getName() + paramsString(t)
// select api order by api
// * get count of all modelled topjdkapis
select count(string api |
    exists(TopJdkApi t |
      /*t.hasMadModel() and*/
      api =
        t.getDeclaringType().getPackage() + "." + t.getDeclaringType().getSourceDeclaration() + "#" +
          t.getName() + paramsString(t)
    )
  )
// from TopJdkApi t
// where t.hasMadModel()
// select t order by t
