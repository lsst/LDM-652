DOCTYPE = LDM
DOCNUMBER = 652
DOCNAME = $(DOCTYPE)-$(DOCNUMBER)
JOBNAME = $(DOCNAME)
TEX = $(filter-out $(wildcard *acronyms.tex) , $(wildcard *.tex))  

#export TEXMFHOME = lsst-texmf/texmf

# Version information extracted from git.
GITVERSION := $(shell git log -1 --date=short --pretty=%h)
GITDATE := $(shell git log -1 --date=short --pretty=%ad)
GITSTATUS := $(shell git status --porcelain)
ifneq "$(GITSTATUS)" ""
	GITDIRTY = -dirty
endif

$(JOBNAME).pdf: $(DOCNAME).tex meta.tex
	xelatex -jobname=$(JOBNAME) $(DOCNAME)
	bibtex $(JOBNAME)
	xelatex -jobname=$(JOBNAME) $(DOCNAME)
	xelatex -jobname=$(JOBNAME) $(DOCNAME)
	xelatex -jobname=$(JOBNAME) $(DOCNAME)

.FORCE:

meta.tex: Makefile .FORCE
	rm -f $@
	touch $@
	echo '% GENERATED FILE -- edit this in the Makefile' >>$@
	/bin/echo '\newcommand{\lsstDocType}{$(DOCTYPE)}' >>$@
	/bin/echo '\newcommand{\lsstDocNum}{$(DOCNUMBER)}' >>$@
	/bin/echo '\newcommand{\vcsrevision}{$(GITVERSION)$(GITDIRTY)}' >>$@
	/bin/echo '\newcommand{\vcsdate}{$(GITDATE)}' >>$@

clean:
	rm -f $(DOCNAME).aux
	rm -f $(DOCNAME).fdb_latexmk
	rm -f $(DOCNAME).fl
	rm -f $(DOCNAME).log
	rm -f $(DOCNAME).out
	rm -f $(DOCNAME).pdf
	rm -f $(DOCNAME).toc
	rm -f -R _build

acronyms.tex : ${TEX} myacronyms.txt skipacronyms.txt
	echo ${TEXMFHOME}
	python3 ${TEXMFHOME}/../bin/generateAcronyms.py   $(TEX)
    
