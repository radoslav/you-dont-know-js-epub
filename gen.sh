#!/usr/bin/env bash

# NOTE: this file is a modified version of gist:
# https://gist.github.com/bmaupin/6e3649af73120fac2b6907169632be2c

mkdir -p output

ROOT_DIR=$PWD
FONT_PATH=/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf

PANDOC_FLAGS=(
  -f markdown+smart
  --epub-embed-font="$FONT_PATH"
  --css="$ROOT_DIR/epub.css"
  --syntax-highlighting=pygments
)

build_book() {
  local author="$1"
  local series_title="$2"
  local book_title="$3"
  local cover="$4"
  shift 4
  local chapters=("$@")

  echo "Generating: $book_title..."

  pandoc \
    "${PANDOC_FLAGS[@]}" \
    -M author="$author" \
    -M title="$series_title: $book_title" \
    -o "$ROOT_DIR/output/$series_title - $book_title.epub" \
    --epub-cover-image="$cover" \
    "${chapters[@]}"
}

# Clean up redundant headings that end up getting split into separate chapters by themselves
find . -iname "*.md" -exec sed -i '/# You Don'\''t Know JS.*/d' {} \;
# Fix <br> tags which pandoc won't convert to <br />
find . -iname "*.md" -exec sed -i 's#<br>#<br />#g' {} \;
# Close img tags
find . -iname "*.md" -exec sed -i -r 's#(<img.*[^/])>#\1 />#' {} \;


TITLE="You Don't Know JS Yet"
AUTHOR="Kyle Simpson"

BOOK1="Get Started"
BOOK2="Scope & Closures"
BOOK3="Objects & Classes"
BOOK4="Types & Grammar"
BOOK5="Sync & Async"
BOOK6="ES.Next & Beyond"

echo "Preparing..."

cd "$ROOT_DIR/2nd-edition"

( cd "get-started" && build_book "$AUTHOR" "$TITLE" "$BOOK1" "images/cover.png" \
  foreword.md \
  ../preface.md \
  ch1.md \
  ch2.md \
  ch3.md \
  ch4.md \
  apA.md \
  apB.md )

( cd "scope-closures" && build_book "$AUTHOR" "$TITLE" "$BOOK2" "images/cover.png" \
  foreword.md \
  ../preface.md \
  ch1.md \
  ch2.md \
  ch3.md \
  ch4.md \
  ch5.md \
  ch6.md \
  ch7.md \
  ch8.md \
  apA.md \
  apB.md )


# ==== NOTE: the 4 books below are from the 1st edition ====

cd "$ROOT_DIR/1st-edition"

TITLE="You Don't Know JS"

BOOK3="this & Object Prototypes"
BOOK4="Types & Grammar"
BOOK5="Async & Performance"
BOOK6="ES6 & Beyond"

( cd "this & object prototypes" && build_book "$AUTHOR" "$TITLE" "$BOOK3" "cover.jpg" \
  foreword.md \
  ../preface.md \
  ch1.md \
  ch2.md \
  ch3.md \
  ch4.md \
  ch5.md \
  ch6.md \
  apA.md \
  apB.md )

( cd "types & grammar" && build_book "$AUTHOR" "$TITLE" "$BOOK4" "cover.jpg" \
  foreword.md \
  ../preface.md \
  ch1.md \
  ch2.md \
  ch3.md \
  ch4.md \
  ch5.md \
  apA.md \
  apB.md )

( cd "async & performance" && build_book "$AUTHOR" "$TITLE" "$BOOK5" "cover.jpg" \
  foreword.md \
  ../preface.md \
  ch1.md \
  ch2.md \
  ch3.md \
  ch4.md \
  ch5.md \
  ch6.md \
  apA.md \
  apB.md \
  apC.md )

( cd "es6 & beyond" && build_book "$AUTHOR" "$TITLE" "$BOOK6" "cover.jpg" \
  foreword.md \
  ../preface.md \
  ch1.md \
  ch2.md \
  ch3.md \
  ch4.md \
  ch5.md \
  ch6.md \
  ch7.md \
  ch8.md \
  apA.md )

echo "Done."
