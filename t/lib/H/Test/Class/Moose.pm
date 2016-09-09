package H::Test::Class::Moose;

use Moose::Exporter;
use MooseX::SemiAffordanceAccessor ();
use MooseX::StrictConstructor      ();

use g;
use namespace::autoclean ();

use H::Container;
use Import::Into;
use Specio::Declare;
use Test::Class::Moose      ();
use Test2::Bundle::Extended ();

my ($import) = Moose::Exporter->setup_import_methods;

# It'd be nice to somehow just reuse Gob::Moose instead of copying it's
# implementation here, but attempting to do that didn't seem to work so well.
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

    $for_class->meta->add_attribute(
        container => (
            is       => 'ro',
            isa      => object_isa_type('H::Container'),
            required => 1,
        ),
    );

    return;
}

1;
