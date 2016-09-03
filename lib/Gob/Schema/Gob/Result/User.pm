#<<<
use utf8;
package Gob::Schema::Gob::Result::User;

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
__PACKAGE__->table("user");
__PACKAGE__->add_columns(
  "user_id",
  {
    data_type => "uuid",
    default_value => \"uuid_generate_v4()",
    is_nullable => 0,
    size => 16,
  },
  "email",
  { data_type => "email", is_nullable => 0 },
  "password",
  { data_type => "char", is_nullable => 0, size => 31 },
  "name",
  { data_type => "citext", is_nullable => 0 },
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
__PACKAGE__->set_primary_key("user_id");
__PACKAGE__->add_unique_constraint("user_email_key", ["email"]);
__PACKAGE__->has_many(
  "applications",
  "Gob::Schema::Gob::Result::Application",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "resumes",
  "Gob::Schema::Gob::Result::Resume",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
#>>>

# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-09-03 11:23:34
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:z+9IAk+/coTkKr41Rre0aA

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
