package H::Fixtures;

use Gob::Moose;

use Gob::Schema::Gob;
use H::Fixtures::DB;
use Specio::Declare;

has schema => (
    is       => 'ro',
    isa      => object_isa_type('Gob::Schema::Gob'),
    required => 1,
);

sub with_fixtures ( $self, @fixtures ) {

}

__PACKAGE__->meta->make_immutable;

1;
