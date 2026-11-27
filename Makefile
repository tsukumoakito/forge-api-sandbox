ZIG ?= zig
ZIG_VERSIONS ?= 0.17.1 0.16.0
SRC := src/main.zig
OUT_DIR ?= dist

ifeq ($(OS),Windows_NT)
	EXE_EXT := .exe
else
	EXE_EXT :=
endif

OUT_BIN ?= $(OUT_DIR)/sandbox-zig$(EXE_EXT)

.PHONY: all build test run clean zvm-test

all: build test run

build:
	@mkdir -p $(OUT_DIR)
	$(ZIG) version
	$(ZIG) build-exe $(SRC) -O ReleaseSafe -femit-bin=$(OUT_BIN)

test:
	$(ZIG) test $(SRC)

run: build
	@case "$(OUT_BIN)" in /*|[A-Za-z]:*) "$(OUT_BIN)" ;; *) "./$(OUT_BIN)" ;; esac

clean:
	rm -rf $(OUT_DIR) .zig-cache zig-out *.o *.pdb

# ローカル検証用: zvm で 0.17.1 / 0.16.0 を切り替えながらコンパイル＆動作確認
zvm-test:
	@command -v zvm >/dev/null 2>&1 || { echo "Error: zvm command not found in PATH" >&2; exit 1; }
	@for v in $(ZIG_VERSIONS); do \
		echo "=========================================="; \
		echo ">>> [zvm] Switching to Zig $$v"; \
		echo "=========================================="; \
		zvm ls 2>/dev/null | grep -q "$$v" || zvm i "$$v"; \
		zvm use "$$v"; \
		PATH="$(HOME)/.zvm/bin:$$PATH" $(MAKE) clean build test run OUT_DIR="dist/zig-$$v"; \
	done
