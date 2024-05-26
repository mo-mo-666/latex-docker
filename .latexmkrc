#!/usr/bin/env perl

# uplatex
$latex = 'uplatex %O -kanji=utf8 -no-guess-input-enc -file-line-error -synctex=1 -interaction=nonstopmode %S';

# upbibtex
$bibtex = 'upbibtex';

# div -> pdf
$dvipdf = 'dvipdfmx %O -o %D %S';

# index
$makeindex = 'upmendex %O -o %D %S';

$max_repeat = 5;

# dvi -> pdf
$pdf_mode = 3;

# preview update
# $pdf_update_method = 4;
