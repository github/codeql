import java


/**
 * The class `com.alibaba.fastjson.JSON`.
 */
class FastJson extends RefType {
    FastJson() { 
        this.hasQualifiedName("com.alibaba.fastjson", "JSON") or
        this.hasQualifiedName("com.alibaba.fastjson", "JSONObject")
    }
}

/** 
 * A call to a parse method of `JSON`. 
 * sink
 * */
class FastJsonParse extends MethodAccess {
    FastJsonParse() {
        exists(Method m |
            m.getDeclaringType() instanceof FastJson and
            (m.hasName("parse") or m.hasName("parseObject")) and
            m = this.getMethod()
        )
    }
}