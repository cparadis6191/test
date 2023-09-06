INPUTS = $(filter-out index.md, $(wildcard *.md **/*.md))
OUTPUTS = $(INPUTS:.md=.html)

CSS = simple.css
DIAGRAM_LUA = diagram.lua

all: index.html

index.html: index.md
	pandoc --css=$(CSS) --embed-resources --metadata=title:$(basename $<) --standalone \
		--from=markdown $< --output=$@

index.md: $(OUTPUTS)
	echo '# Index\n' > $@
	$(foreach output,$(OUTPUTS),echo '* [$(output)]($(output))' >> $@;)

%.html: %.md $(DIAGRAM_LUA)
	pandoc --css=$(CSS) --embed-resources --lua-filter=$(DIAGRAM_LUA) --metadata=title:$(basename $<) \
		--standalone \
		--from=markdown $< --output=$@

$(CSS):
	curl --location --remote-name \
	https://github.com/kevquirk/$(CSS)/raw/v2.2.1/$(CSS)

$(DIAGRAM_LUA):
	curl --location --remote-name \
	https://raw.githubusercontent.com/pandoc-ext/diagram/v1.0.0/_extensions/diagram/$(DIAGRAM_LUA)

.PHONY: clean

clean:
	rm --force $(CSS) $(DIAGRAM_LUA) index.html index.md $(OUTPUTS)
