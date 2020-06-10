import java


/**
 * The class `com.alibaba.fastjson.JSON` or `com.alibaba.fastjson.JSONObject`.
 */
class FastJson extends RefType {
    FastJson() { 
        this.hasQualifiedName("com.alibaba.fastjson", "JSON") or
        this.hasQualifiedName("com.alibaba.fastjson", "JSONObject")
    }
}

/** 
 * Call the parsing method of `JSON` or `JSONObject`. 
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