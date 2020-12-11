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

| add run.sh to profiling it (generate flamegraph)

Usage:
---

```bash
bash run.sh prof
```