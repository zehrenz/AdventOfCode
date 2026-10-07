default:
    just --list

setup year day:
    dart run ./utils/bin/setup.dart {{year}} {{day}}

setup-year year:
    dart run ./utils/bin/setup_year.dart {{year}}

fetch year day:
    dart run ./utils/bin/fetch.dart {{year}} {{day}}

fetch-year year:
    dart run ./utils/bin/fetch.dart {{year}}

fetch-all:
    @status=0; \
    for year in [0-9][0-9][0-9][0-9]; do \
        [ -d "$year" ] || continue; \
        printf '\nFetching %s\n' "$year"; \
        just fetch-year "$year" || status=1; \
    done; \
    exit "$status"

submit year day part:
    dart run ./utils/bin/submit.dart {{year}} {{day}} {{part}}

runc year day:
    just compile {{year}} {{day}}
    ./{{year}}/exe/day{{day}}.exe

run year day: 
    dart run {{year}}/bin/day{{day}}.dart

test year day:
    dart run {{year}}/test/day{{day}}_test.dart

test-year year:
    AOC_BASE_DIR="$PWD/{{year}}/test" dart test "{{year}}/test"

test-all:
    @passed=0; failed=0; failed_years=""; \
    for test_dir in [0-9][0-9][0-9][0-9]/test; do \
        [ -d "$test_dir" ] || continue; \
        year="${test_dir%/test}"; \
        printf '\nTesting %s\n' "$year"; \
        if just test-year "$year"; then \
            passed=$((passed + 1)); \
        else \
            failed=$((failed + 1)); failed_years="$failed_years $year"; \
        fi; \
    done; \
    printf '\nYear suites: %s passed, %s failed\n' "$passed" "$failed"; \
    if [ "$failed" -gt 0 ]; then \
        printf 'Failed years:%s\n' "$failed_years"; exit 1; \
    fi

compile year day:
    mkdir -p ./{{year}}/exe
    dart compile exe {{year}}/bin/day{{day}}.dart -o {{year}}/exe/day{{day}}.exe

time year:
    dart run ./utils/bin/benchmark_year.dart {{year}}

timed year day:
    dart run ./utils/bin/benchmark_day.dart {{year}} {{day}} --write

install:
    @if ! command -v lefthook >/dev/null 2>&1; then \
        echo "Error: lefthook is not installed."; \
        echo "Install it here: https://lefthook.dev/install/"; \
        exit 1; \
    fi
    dart pub get --no-example