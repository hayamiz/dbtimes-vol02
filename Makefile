
.PHONY: check

TIMESTAMP := $(shell date +%Y%m%d-%H%M%S)
PDFDIR := /home/haya/public_html/files/dbtimes-vol02

book.pdf:
	omake book.pdf

check:
	platex -interaction=batchmode book.tex
	platex -interaction=batchmode book.tex
	omake --verbose book-ready.pdf
	export COMMIT_HEAD=`git log|head -n1|awk '{print $$2}'` \
	 && export tmpdir=`mktemp -d` && echo $$tmpdir && (cd $$tmpdir && \
	 echo "\\\\documentclass{article}\n\\\\setlength{\\\\oddsidemargin}{-20mm}\\\\setlength{\\\\topmargin}{-38mm}\\\\setlength{\\\\textwidth}{200mm}\n\\\\pagestyle{empty}\n\\\\begin{document}\n{\\\\tt $${COMMIT_HEAD}}: Generated at `LANG=C date`\n\\\\end{document}" > time.tex && \
	 platex time.tex && dvipdfmx -o time.pdf time.dvi) && cp $$tmpdir/time.pdf ./ && rm -rf $$tmpdir
	pdftk book-ready.pdf stamp time.pdf output book-ready-stamped.pdf
	rm -f time.pdf
	mv book-ready-stamped.pdf $(PDFDIR)/book-ready-$(TIMESTAMP).pdf
	rm -f $(PDFDIR)/book-ready-latest.pdf
	ln -s $(PDFDIR)/book-ready-$(TIMESTAMP).pdf $(PDFDIR)/book-ready-latest.pdf
