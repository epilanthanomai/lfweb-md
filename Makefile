ALL_DIRS:=$(shell find pages -type d)
ALL_MD:=$(shell find pages -name *.md)

BUILD_DIRS:=$(patsubst %,build/%,$(ALL_DIRS))
BUILD_HTML:=$(patsubst %.md,build/%.html,$(ALL_MD))

COPY_SOURCE:=$(ALL_MD)
BUILD_COPY:=$(patsubst %,build/%,$(COPY_SOURCE))

PANDOC_OPTS=--metadata-file=common-metadata.yaml 

.PHONY: default all
default: all
all: $(BUILD_DIRS) $(BUILD_HTML) $(BUILD_COPY)

$(BUILD_DIRS): %:
	@mkdir -p $@

build/%.html: %.md common-metadata.yaml
	pandoc $(PANDOC_OPTS) -t html5 -s -o $@ $<

$(BUILD_COPY): build/%: %
	cp $< $@

.PHONY: clean
clean:
	rm -rf build
