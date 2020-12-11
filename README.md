Clover: Cis-eLement OVERrepresentation
======================================

Introduction
------------
Clover is a program for identifying functional sites in DNA
sequences. If you give it a set of DNA sequences that share a common
function, it will compare them to a library of sequence motifs
(e.g. transcription factor binding patterns), and identify which if
any of the motifs are statistically overrepresented in the sequence
set.
https://github.com/mcfrith/clover

What did I do?
---
add run.sh to profiling clover and generate flamegraph

Resolve dependency:
---
```bash
sudo apt install linux-tools-common

cd ${CLONEPATH}
git clone git@github.com:brendangregg/FlameGraph.git
export PATH=${CLONEPATH}:$PATH
```

Usage:
---
```bash
bash run.sh prof
```
