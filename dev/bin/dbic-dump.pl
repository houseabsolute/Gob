#!/usr/bin/env perl

use FindBin qw($Bin);
use lib "$Bin/../../lib", "$Bin/../lib";

use g;

use Gob::DBICDumper;

exit Gob::DBICDumper->new_with_options->run;
