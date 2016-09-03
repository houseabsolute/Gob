#<<<
use utf8;
package Gob::Schema::Gob::Result::Posting;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'Gob::Schema::Gob::Result';
use g;
__PACKAGE__->load_components(
  "InflateColumn::DateTime",
  "InflateColumn::Serializer",
  "TimeStamp",
);
__PACKAGE__->table("posting");
__PACKAGE__->add_columns(
  "posting_id",
  {
    data_type => "uuid",
    default_value => \"uuid_generate_v4()",
    is_nullable => 0,
    size => 16,
  },
  "title",
  { data_type => "citext", is_nullable => 0 },
  "description",
  { data_type => "text", is_nullable => 0 },
  "flow",
  { data_type => "jsonb", is_nullable => 0, serializer_class => "JSON" },
  "created_at",
  {
    data_type     => "timestamp with time zone",
    default_value => \"current_timestamp",
    is_nullable   => 1,
    original      => { default_value => \"now()" },
  },
  "last_updated_at",
  {
    data_type     => "timestamp with time zone",
    default_value => \"current_timestamp",
    is_nullable   => 1,
    original      => { default_value => \"now()" },
  },
);
__PACKAGE__->set_primary_key("posting_id");
__PACKAGE__->has_many(
  "applications",
  "Gob::Schema::Gob::Result::Application",
  { "foreign.posting_id" => "self.posting_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
#>>>

# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-09-03 11:23:34
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Ld0zl1QrTtRcyT0KIIr1hQ

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
