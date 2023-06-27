## Customize Makefile settings for parco-test-module
## 
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile

.PHONY: all
all: templates components/vocabulary.owl all_odk 

TEMPLATESDIR=../templates

TEMPLATES=$(patsubst %.tsv, $(TEMPLATESDIR)/%.owl, $(notdir $(wildcard $(TEMPLATESDIR)/*.tsv)))

$(TEMPLATESDIR)/%.owl: $(TEMPLATESDIR)/%.tsv $(SRC)
	$(ROBOT) merge -i $(SRC) template --prefix "parco: http://si.eu-parc.eu/PARCO-" --template $< --output $@ && \
			  $(ROBOT) annotate --input $@ --ontology-iri $(ONTBASE)/components/$*.owl -o $@
		  
components/vocabulary.owl: $(TEMPLATES)
	  $(ROBOT) merge $(patsubst %, -i %, $^) \
			    annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ \
					    --output $@.tmp.owl && mv $@.tmp.owl $@
		    
templates: $(TEMPLATES)
	  echo $(TEMPLATES)

