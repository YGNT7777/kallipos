#!/bin/sh
#assemble and preprocess all the sources files
#Generating latex file
mkdir -p latex


pandoc text/pre.txt --lua-filter=epigraph.lua --to markdown | pandoc --top-level-division=chapter --to latex > latex/pre.tex
pandoc text/intro.txt --lua-filter=epigraph.lua --to markdown | pandoc --top-level-division=chapter --to latex > latex/intro.tex

for filename in text/ch*.txt; do
   [ -e "$filename" ] || continue
   pandoc --lua-filter=extras.lua "$filename" --to markdown | pandoc --lua-filter=extras.lua --to markdown | pandoc --lua-filter=epigraph.lua --to markdown | pandoc --lua-filter=figure.lua --to markdown | pandoc --lua-filter=footnote.lua --to markdown | pandoc --metadata-file=meta.yml --filter pandoc-crossref --to markdown | pandoc --top-level-division=chapter --citeproc --bibliography=bibliography/"$(basename "$filename" .txt).bib" --reference-location=section --wrap=none --to latex > latex/"$(basename "$filename" .txt).tex"
done

pandoc text/web.txt --lua-filter=epigraph.lua --to markdown | pandoc --top-level-division=chapter --to latex > latex/web.tex
pandoc text/bio.txt --top-level-division=chapter --to latex > latex/bio.tex

for filename in text/apx*.txt; do
   [ -e "$filename" ] || continue
   pandoc --lua-filter=extras.lua "$filename" --to markdown | pandoc --lua-filter=extras.lua --to markdown | pandoc --lua-filter=epigraph.lua --to markdown | pandoc --lua-filter=figure.lua --to markdown | pandoc --metadata-file=meta.yml --filter pandoc-crossref --to markdown | pandoc --top-level-division=chapter --citeproc --bibliography=bibliography/"$(basename "$filename" .txt).bib" --reference-location=section --to latex > latex/"$(basename "$filename" .txt).tex"
done

#Fixing image path on tex files
sed -i 's|\.\./images/|images/|g' latex/*.tex

echo "Generating book.tex"
pandoc -s latex/*.tex -o book/book.tex

echo " Generating pdf file"
pandoc -N --quiet --variable "geometry=margin=1.2in" --variable mainfont="DejaVuSans-Bold.ttf" --variable monofont="DejaVuSans-Bold.ttf" --variable version=2.0 book/book.tex --pdf-engine=xelatex --toc -o book/book.pdf

echo "Done"
