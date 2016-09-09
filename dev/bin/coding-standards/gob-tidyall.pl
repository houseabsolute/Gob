#!/usr/bin/env perl

use strict;
use warnings;

local $ENV{PERL5LIB} = join ':', grep {defined} 'lib', 'dev/lib',
    $ENV{PERL5LIB};
exit !exec( 'tidyall', @ARGV );
