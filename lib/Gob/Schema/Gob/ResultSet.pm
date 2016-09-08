package Gob::Schema::Gob::ResultSet;

use Gob::Moose;

extends 'DBIx::Class::ResultSet';

__PACKAGE__->load_components(
    qw(
        Helper::ResultSet::OneRow
        Helper::ResultSet::Shortcut::Columns
        Helper::ResultSet::Shortcut::Distinct
        Helper::ResultSet::Shortcut::GroupBy
        Helper::ResultSet::Shortcut::HasRows
        Helper::ResultSet::Shortcut::HRI
        Helper::ResultSet::Shortcut::Limit
        Helper::ResultSet::Shortcut::OrderBy
        Helper::ResultSet::Shortcut::Rows
        )
);

__PACKAGE__->meta->make_immutable( inline_constructor => 0 );

1;
