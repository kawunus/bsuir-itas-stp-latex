# Use .DEFAULT_GOAL for modern Makefiles to set the default target.
.DEFAULT_GOAL := help

# Project sources and output
SRC_DIR      := note
MAIN_TEX     := note.tex
OUTPUT_PDF   := $(patsubst %.tex,%.pdf,$(MAIN_TEX))

DOCKER_IMAGE := neitex:latex
DOCKER_CMD   := docker run --rm --user="$$(id -u):$$(id -g)" --net=none -v "$(CURDIR)/$(SRC_DIR):/work" -w=/work $(DOCKER_IMAGE)

# latexmk command and flags
LATEXMK_FLAGS := -xelatex -shell-escape -interaction=nonstopmode -synctex=1
LATEXMK       := $(DOCKER_CMD) latexmk $(LATEXMK_FLAGS)

TEX_SOURCES   := $(shell find $(SRC_DIR) -type f -name "*.tex")
BIB_SOURCES   := $(shell find $(SRC_DIR) -type f -name "*.bib")
STYLE_SOURCES := $(shell find $(SRC_DIR) -type f \( -name "*.cls" -o -name "*.sty" \))


# --- Targets ---

# Define targets that don't correspond to file names.
.PHONY: all build clean pvc help

ALL_SOURCES := $(TEX_SOURCES) $(BIB_SOURCES) $(STYLE_SOURCES)

# The `all` target is a common convention for the main build process.
all: $(OUTPUT_PDF)
	@echo "✅ Build complete: $(OUTPUT_PDF) is ready."

$(OUTPUT_PDF): $(SRC_DIR)/$(OUTPUT_PDF)
	@echo "==> Copying build artifact to project root..."
	@cp $< $@

$(SRC_DIR)/$(OUTPUT_PDF): $(ALL_SOURCES)
	@echo "==> Building LaTeX document inside Docker..."
	@$(LATEXMK) $(MAIN_TEX)

build: $(SRC_DIR)/$(OUTPUT_PDF)

pvc:
	@echo "==> Starting latexmk in continuous mode (pvc)..."
	@$(LATEXMK) -pvc $(MAIN_TEX)

clean:
	@echo "==> Cleaning up generated files..."
	@rm -f $(OUTPUT_PDF)
	@$(DOCKER_CMD) latexmk -C

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  all (default)  Build the PDF and copy it to the project root."
	@echo "  build          Build the PDF inside the '$(SRC_DIR)' directory only."
	@echo "  pvc            Run latexmk in continuous mode for live updates."
	@echo "  clean          Remove all generated files (PDF, aux, log, etc.)."
	@echo "  help           Show this help message."
