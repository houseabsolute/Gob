package T::Gob::Types;

use H::Test::Class::Moose;

use Devel::PartialDump;
use Gob::Types;

sub test_types ( $self, @ ) {
    my %tests = (
        MethodName => {
            valid =>
                [ 'foo', 'foo23', '___', '_foo', "\x{34b0}", "_\x{34b0}" ],
            invalid => [ '1foo', q{ }, 'foo bar', q{!}, { foo => 42 } ],
        },
    );

    for my $type ( sort keys %tests ) {
        subtest(
            $type => sub {
                $self->_test_type( $type => $tests{$type} );
            }
        );
    }
}

sub _test_type ( $self, $name, $tests ) {
    my $type = t($name);
    subtest(
        'valid' => sub {
            for my $v ( sort $tests->{valid}->@* ) {
                ok( $type->value_is_valid($v), _v($v) . ' is valid' );
            }
        }
    );
    subtest(
        'invalid' => sub {
            for my $v ( sort $tests->{invalid}->@* ) {
                ok( !$type->value_is_valid($v), _v($v) . ' is invalid' );
            }
        }
    );
}

sub _v ($v) {
    return Devel::PartialDump->new->dump($v);
}

__PACKAGE__->meta->make_immutable;

1;
