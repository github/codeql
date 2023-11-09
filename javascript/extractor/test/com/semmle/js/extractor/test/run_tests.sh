NODE=$1
JAVA=$2
PARSER_WRAPPER=$3
TEST_JAR=$4

TEMP=$(mktemp -d)

UNAME=$(uname -s)
echo $UNAME
# On Windows, the symlink set up by bazel that points at the test jar is a msys2/linux-style path
# The JVM can't resolve that, therefore copy the jar to the temp directory, and then set the
# windows path to it
if [[ "$UNAME" =~ _NT ]]; then
    cp $TEST_JAR $TEMP/test.jar
    TEST_JAR=$(cygpath -w $TEMP/test.jar)
    echo "On Windows, new test jar: $TEST_JAR"
fi

# unpack parser wrapper
unzip -q $PARSER_WRAPPER -d $TEMP/parser_wrapper
export SEMMLE_TYPESCRIPT_PARSER_WRAPPER=$TEMP/parser_wrapper/javascript/tools/typescript-parser-wrapper/main.js

# setup node on path
NODE=$(realpath $NODE)
export PATH="$PATH:$(dirname $NODE)"

$JAVA -Dbazel.test_suite=com.semmle.js.extractor.test.AllTests -jar $TEST_JAR
EXIT_CODE=$?

rm -rf $TEMP
exit $EXIT_CODE
