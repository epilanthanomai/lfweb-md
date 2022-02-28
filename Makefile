.PHONY: default
default: all

SRC_DIRS:=$(shell find webroot -type d)
SRC_FILES:=$(shell find webroot -type f)

BUILD_DIRS=$(patsubst %,build/%,$(SRC_DIRS))
BUILD_FILES=$(patsubst %,build/%,$(SRC_FILES))

define transform =
GEN_$(2)_$(1)=$$(patsubst %.$(1),%.$(2),$$(or $(3),$$(filter %.$(1),$$(BUILD_FILES))))
GEN_ALL+=$$(GEN_$(2)_$(1))
endef

$(eval $(call transform,md,html))
PANDOC_OPTS=\
	--metadata-file=common-metadata.yaml \
	--section-divs
%.html: %.md common-metadata.yaml
	pandoc $(PANDOC_OPTS) -t html5 -s -o $@ $<

BUILD_SCSS_ALL:=$(filter %.scss,$(BUILD_FILES))
BUILD_SCSS_CONVERT:=$(foreach f,$(BUILD_SCSS_ALL),$(if $(findstring /_,$f),,$f))
$(eval $(call transform,scss,css,$(BUILD_SCSS_CONVERT)))
%.css: %.scss
	sass $< $@

.PHONY: all
all: $(BUILD_DIRS) $(BUILD_FILES) $(GEN_ALL)

$(BUILD_DIRS): %:
	@mkdir -p $@

$(BUILD_FILES): build/%: %
	@cp $< $@

.PHONY: clean
clean:
	rm -rf build
