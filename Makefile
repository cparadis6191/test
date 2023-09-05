INPUTS = $(filter-out index.md, $(wildcard *.md))
OUTPUTS = $(INPUTS:.md=.html)

DIAGRAM_LUA = diagram.lua

all: index.html

index.html: index.md
	pandoc --embed-resources --metadata=title:$(basename $<) --standalone \
		--from=markdown $< --output=$@

index.md: $(OUTPUTS)
	echo '# Pages\n' > $@
	$(foreach output,$(OUTPUTS),echo '* [$(output)]($(output))' >> $@;)

%.html: %.md $(DIAGRAM_LUA)
	pandoc --embed-resources --lua-filter=$(DIAGRAM_LUA) --metadata=title:$(basename $<) \
		--standalone \
		--from=markdown $< --output=$@

$(DIAGRAM_LUA):
	curl --location --remote-name \
	https://raw.githubusercontent.com/pandoc-ext/diagram/v1.0.0/_extensions/diagram/$(DIAGRAM_LUA)

.PHONY: clean

clean:
	rm --force index.html $(OUTPUTS)
