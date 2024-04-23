import cpp

class ACompressedFileWrite extends Function {
  ACompressedFileWrite() {
    this.getName() = "operator<<" and
    this.getParameter(0).getType().stripType().getName() = "a_compressed_file"
  }
}

class LabelDefinition extends Call {
  LabelDefinition() {
    this.getTarget() instanceof ACompressedFileWrite and
    this.getArgument(1).(StringLiteral).getValue().matches("=%")
  }
}

predicate is_valid_file_write(Call call) {
    call.getFile().getBaseName() = "dbscheme.cpp"
}

from Call call
where
  call.getTarget() instanceof ACompressedFileWrite
  and not is_valid_file_write(call)
select call
