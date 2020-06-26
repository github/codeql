import go

from Protobuf::MessageType msgTyp
where msgTyp.(PointerType).getBaseType().hasQualifiedName("codeql-go-tests/protobuf/protos/query", _)
select msgTyp.pp()
