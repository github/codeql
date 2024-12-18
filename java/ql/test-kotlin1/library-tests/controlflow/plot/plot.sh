codeql database analyze ../basic/basic.testproj --format=dot nodeGraph.ql --output=outdir --rerun
dot -Tpdf -O outdir/test-plot-cfg.dot
open outdir/test-plot-cfg.dot.pdf