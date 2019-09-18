BASEDIR=$(dirname "$0")

cat > "$BASEDIR/reformat.vim" <<"EOF"
:set ff=unix ts=2 et
:retab!
:%s/\r//g
:%s/ \+$//
:wq
EOF

find "$BASEDIR" \( -name "*.ql" -or -name "*.qll" -or -name "*.csv" -or -name "*.config" \) -exec vim -u /dev/null -s reformat.vim {} \;

cat > reformat.vim <<"EOF"
:set ff=unix ts=4 et
:retab!
:%s/\r//g
:%s/ \+$//
:wq
EOF

find "$BASEDIR" \( -name "*.cs" \) -exec vim -u /dev/null -s reformat.vim {} \;

rm "$BASEDIR/reformat.vim"
