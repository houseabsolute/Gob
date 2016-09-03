package H::Test::Class::Moose;

use Moose::Exporter;
use MooseX::SemiAffordanceAccessor ();
use MooseX::StrictConstructor      ();

use g;

use Import::Into;
use Test::Class::Moose      ();
use Test2::Bundle::Extended ();
use namespace::autoclean    ();

my ($import) = Moose::Exporter->setup_import_methods;

sub import {
    my $for_class = caller();

    $import->( undef, { into => $for_class } );

    my $caller_level = 1;
    Test::Class::Moose->import::into( $caller_level, bare => 1 );
    Test2::Bundle::Extended->import::into( $caller_level, '!meta' );

    MooseX::SemiAffordanceAccessor->import( { into => $for_class } );

    # TCM passes all of its config k/v pairs to each test class (annoyingly)
    # so we cannot use MX::StrictConstructor.

    g->import::into($caller_level);
    namespace::autoclean->import::into($caller_level);
}

1;
