RDIR=./R
DATAS=$(wildcard $(RDIR)/data/*)
RFILES=$(wildcard $(RDIR)/*.R)
OUT_FILES=$(RFILES:.R=.Rout)
TEXDIR=./latex
TEXFILE=$(TEXDIR)/cr
TEXDEPS=$(wildcard $(TEXDIR)/*.bib $(TEXDIR)/*.cls)
FIGDIR=$(TEXDIR)/img
FIG_FILES=$(FIGDIR)/dyn_pearson.tex $(FIGDIR)/dyn_bibliometry.tex

R=R CMD BATCH
R_ARGS=--no-restore --no-save
LATEX=latexmk
L_ARGS=-cd -gg -pdf -quiet
VIEWER=zathura 2>/dev/null
OPTIMIZER=./optimize_pdf.sh

all: report

report: $(TEXFILE).pdf

$(TEXFILE).pdf: $(TEXFILE).tex $(TEXDEPS) $(RFILES) $(FIG_FILES)
	$(LATEX) $(L_ARGS) $(TEXFILE)

$(FIG_FILES): $(RDIR)/script.Rout

$(RDIR)/script.Rout: $(RFILES) $(DATAS)
	mkdir -p $(TEXDIR)/img
	$(R) $(R_ARGS) $< $@

view: $(TEXFILE).pdf
	$(VIEWER) $< &

optimize: $(TEXFILE).pdf
	$(OPTIMIZER) $(TEXFILE).pdf

.PHONY: clean mrproper

cleantex:
	rm -rfv $(TEXDIR)/*.aux
	rm -rfv $(TEXDIR)/*.log
	rm -rfv $(TEXDIR)/*.blg
	rm -rfv $(TEXDIR)/*.bbl
	rm -rfv $(TEXDIR)/*.xdy
	rm -rfv $(TEXDIR)/*.toc
	rm -rfv $(TEXDIR)/*.synctex.gz
	rm -rfv $(TEXDIR)/*.fls
	rm -rfv $(TEXDIR)/*.gl*
	rm -rfv $(TEXDIR)/*.out
	rm -rfv $(TEXDIR)/*.fdb_latexmk

clean: cleantex
	rm -rfv $(OUT_FILES)

mrproper: clean
	rm -rfv $(TEXFILE).pdf
	rm -rfv $(FIGDIR)/dyn*
