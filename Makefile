INPUTS := $(filter-out index-header.md index.md, $(wildcard *.md **/*.md))
OUTPUTS := $(INPUTS:.md=.html)

CSS := simple.css
DIAGRAM_LUA := diagram.lua

all: index.html

index.html: index.md $(CSS)
	pandoc --css=$(CSS) \
		--embed-resources \
		--metadata=title:$(basename $(notdir $<)) \
		--standalone \
		--from=markdown \
		$< \
		--output=$@

index.md: index-header.md $(OUTPUTS)
	cat $< > $@
	echo '## Index\n' >> $@
	$(foreach output,$(OUTPUTS),echo '* [$(output)]($(output))' >> $@;)

index-header.md:
	echo '# Index Header\n\nThis is the index header!\n' > $@

%.html: %.md $(CSS) $(DIAGRAM_LUA)
	pandoc --css=$(CSS) \
		--embed-resources \
		--lua-filter=$(DIAGRAM_LUA) \
		--metadata=title:$(basename $(notdir $<)) \
		--standalone \
		--from=markdown \
		$< \
		--output=$@

$(CSS):
	curl --location \
		--remote-name \
		https://github.com/kevquirk/simple.css/raw/v2.2.1/simple.css

$(DIAGRAM_LUA):
	curl --location \
		--remote-name \
		https://raw.githubusercontent.com/pandoc-ext/diagram/v1.0.0/_extensions/diagram/diagram.lua

.PHONY: clean

clean:
	rm --force \
		$(CSS) \
		$(DIAGRAM_LUA) \
		index.html \
		index.md \
		$(OUTPUTS)
