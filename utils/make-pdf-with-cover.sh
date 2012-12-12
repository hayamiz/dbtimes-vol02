#!/bin/bash

top_dir=$(dirname $(dirname $(readlink -f $0)))
dist_dir=$top_dir/dist

tmp_dir=`mktemp -d`

(cd $top_dir && omake clobber && omake book-notombo-ready.pdf)

#
# make PDF
#
pdftk A=$top_dir/cover-half.pdf B=$top_dir/book-notombo-ready.pdf cat A B output $dist_dir/dbtimes-vol02.pdf


#
# make sample images for melonbooks DL
#
if ! [ -d $dist_dir/samples ]; then
    mkdir $dist_dir/samples
fi

pdftk $dist_dir/dbtimes-vol02.pdf cat 2  output -|convert - $dist_dir/samples/sample1.png &
pdftk $dist_dir/dbtimes-vol02.pdf cat 4  output -|convert - $dist_dir/samples/sample2.png &
pdftk $dist_dir/dbtimes-vol02.pdf cat 5  output -|convert - $dist_dir/samples/sample3.png &
pdftk $dist_dir/dbtimes-vol02.pdf cat 6  output -|convert - $dist_dir/samples/sample4.png &
pdftk $dist_dir/dbtimes-vol02.pdf cat 8  output -|convert - $dist_dir/samples/sample5.png &
pdftk $dist_dir/dbtimes-vol02.pdf cat 9  output -|convert - $dist_dir/samples/sample6.png &
pdftk $dist_dir/dbtimes-vol02.pdf cat 10 output -|convert - $dist_dir/samples/sample7.png &

wait

#
# make zip file for melonbooks DL
#
cd $tmp_dir
mkdir -p dbtimes-vol02/product
cp $dist_dir/dbtimes-vol02.pdf dbtimes-vol02/product/1.pdf
zip -r dbtimes-vol02.zip dbtimes-vol02/
mv dbtimes-vol02.zip $dist_dir/
cd -
rm -rf $tmp_dir
