cargo build --release

cargo run --release -p ql-generator -- --dbscheme ql/src/ql.dbscheme --library ql/src/codeql_ql/ast/internal/TreeSitter.qll
codeql query format -i ql\src\codeql_ql\ast\internal\TreeSitter.qll

if (Test-Path -Path extractor-pack) {
	rm -Recurse -Force extractor-pack
}
mkdir extractor-pack | Out-Null
cp codeql-extractor.yml, ql\src\ql.dbscheme, ql\src\ql.dbscheme.stats extractor-pack
cp -Recurse tools extractor-pack
mkdir extractor-pack\tools\win64 | Out-Null
cp target\release\ql-extractor.exe extractor-pack\tools\win64\extractor.exe
cp target\release\ql-autobuilder.exe extractor-pack\tools\win64\autobuilder.exe
