package Gob::Model::Posting;

use Gob::Moose;

use Gob::Types;
use Specio::Declare;

has posting_id => (
    is       => 'ro',
    isa      => t('UUID'),
    required => 1,
);

has _posting => (
    is    => 'ro',
    isa   => object_isa_type('Gob::Schema::Result::Flow'),
    lazy  => 1,
    build => '_build_posting',
);

has _flow => (
    is      => 'ro',
    isa     => object_isa_type('Gob::Schema::Result::Flow'),
    lazy    => 1,
    default => sub ($self) { $self->posting->flow },
);

sub _build_posting ($self) {

}

sub next_step_for_application ( $self, $application ) {
    die 'Application is not for this posting'
        unless $self->posting_id eq $self->posting_id;

}

__PACKAGE__->meta->make_immutable;

1;
