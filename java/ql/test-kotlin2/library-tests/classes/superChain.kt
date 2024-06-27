open class SuperChain1<T1, T2> {}
open class SuperChain2<T3, T4>: SuperChain1<T3, String>() {}
open class SuperChain3<T5, T6>: SuperChain2<T5, String>() {}
// This should end up with SuperChain2<T5, String> having
// SuperChain1<T5, String> as a supertype.
