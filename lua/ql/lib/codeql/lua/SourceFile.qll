/**
 * Provides source-file inventory facts for Lua inputs.
 */
class LuaSourceFile extends @lua_source_file {
  string getPath() { lua_source_files(this, _, result, _, _, _) }

  int getLineCount() { lua_source_files(this, _, _, result, _, _) }

  int getByteCount() { lua_source_files(this, _, _, _, result, _) }

  string getSha256() { lua_source_files(this, _, _, _, _, result) }

  string getBaseName() { result = this.getPath().regexpReplaceAll(".*/", "") }

  string toString() { result = this.getPath() }
}
