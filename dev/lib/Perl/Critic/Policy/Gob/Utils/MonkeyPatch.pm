package Perl::Critic::Policy::Gob::Utils::MonkeyPatch;

use g;

use Perl::Critic::Utils;

no warnings 'redefine';

use base 'Perl::Critic::Policy';

sub default_themes { return qw( maxmind ) }
sub violates       { }

## no critic (Modules::ProhibitMultiplePackages)
## no critic (Subroutines::ProhibitUnusedPrivateSubroutines)
## no critic (Subroutines::ProtectPrivateSubs)
## no critic (ProhibitCallsToUnexportedSubs)
{
    package Perl::Critic::Utils;
    no warnings 'redefine';
    use Perl::Critic::Utils qw( $TRUE );

    my %mm_autodie_modules
        = map { $_ => 1 }
        qw( g Gob::Moose Gob::Moose::Role Gob::MooseX::Role::Parameterized H::Test::Class::Moose );

    sub _is_fatal {
        my ($elem) = @_;

        my $top = $elem->top();
        return if not $top->isa('PPI::Document');

        my $includes = $top->find('PPI::Statement::Include');
        return if not $includes;

        for my $include ( @{$includes} ) {
            next if 'use' ne $include->type();

            ## no critic (ControlStructures::ProhibitCascadingIfElse)
            if ( 'Fatal' eq $include->module() ) {
                my @args = parse_arg_list( $include->schild(1) );
                foreach my $arg (@args) {
                    return $TRUE
                        if $arg->[0]->isa('PPI::Token::Quote')
                        && $elem eq $arg->[0]->string();
                }
            }
            elsif ( 'Fatal::Exception' eq $include->module() ) {
                my @args = parse_arg_list( $include->schild(1) );
                shift @args;    # skip exception class name
                foreach my $arg (@args) {
                    return $TRUE
                        if $arg->[0]->isa('PPI::Token::Quote')
                        && $elem eq $arg->[0]->string();
                }
            }
            elsif ( 'autodie' eq $include->pragma() ) {
                return Perl::Critic::Utils::_is_covered_by_autodie(
                    $elem,
                    $include
                );
            }
            elsif ( $mm_autodie_modules{ $include->module() } ) {

                # XXX - we should really check if the built-in is covered by
                # autodie, but it's really hard to do from a monkey patch
                # given how Perl::Critic::Utils is structured.
                return $TRUE;
            }
        }

        return;
    }
}

1;
