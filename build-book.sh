#!/bin/sh
#assemble and preprocess all the sources files

pandoc text/pre.txt --lua-filter=epigraph.lua --to markdown | pandoc --top-level-division=chapter --to latex > book/pre.tex
pandoc text/intro.txt --lua-filter=epigraph.lua --to markdown | pandoc --top-level-division=chapter --to latex > book/intro.tex

for filename in text/ch*.txt; do
   [ -e "$filename" ] || continue
   pandoc --lua-filter=extras.lua "$filename" --to markdown | pandoc --lua-filter=extras.lua --to markdown | pandoc --lua-filter=epigraph.lua --to markdown | pandoc --lua-filter=figure.lua --to markdown | pandoc --lua-filter=footnote.lua --to markdown | pandoc --filter pandoc-fignos --to markdown | pandoc --metadata-file=meta.yml --top-level-division=chapter --citeproc --bibliography=bibliography/"$(basename "$filename" .txt).bib" --reference-location=section --wrap=none --to latex > book/"$(basename "$filename" .txt).tex"
done

pandoc text/web.txt --lua-filter=epigraph.lua --to markdown | pandoc --top-level-division=chapter --to latex > book/web.tex
pandoc text/bio.txt --top-level-division=chapter --to latex > book/bio.tex

for filename in text/apx*.txt; do
   [ -e "$filename" ] || continue
   pandoc --lua-filter=extras.lua "$filename" --to markdown | pandoc --lua-filter=extras.lua --to markdown | pandoc --lua-filter=epigraph.lua --to markdown | pandoc --lua-filter=figure.lua --to markdown | pandoc --filter pandoc-fignos --to markdown | pandoc --metadata-file=meta.yml --top-level-division=chapter --citeproc --bibliography=bibliography/"$(basename "$filename" .txt).bib" --reference-location=section --to latex > book/"$(basename "$filename" .txt).tex"
done
