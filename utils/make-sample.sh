#!/bin/bash

top_dir=$(dirname $(dirname $(readlink -f $0)))
dist_dir=$top_dir/dist

tmp_dir=`mktemp -d`

(cd $top_dir && omake book-notombo-ready.pdf)

#
# make PDF
#
pdftk A=$top_dir/cover-half-raster.pdf B=$top_dir/book-notombo-ready.pdf \
      C=$top_dir/miserarenaiyo.pdf D=$top_dir/senden.pdf \
      cat A D B1 B3-4 B5 C B11-13 C B21-22 C B27 C B29-31 C B43-44 C B47 C B52 \
      output $dist_dir/dbtimes-vol02-sample.pdf
