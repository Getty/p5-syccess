#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

for (qw(
  Syccess
  Syccess::Error
  Syccess::Field
  Syccess::Result
  Syccess::Validator
  Syccess::ValidatorSimple
)) {
  use_ok($_);
}

done_testing;
