import extlib.GenericTypeKotlin;
import extlib.RawTypesInSignatureKotlin;

fun test() {

  val rawGt = GenericTypeKotlin.getRaw()
  val rtis = RawTypesInSignatureKotlin()
  rtis.directParameter(null)

}

