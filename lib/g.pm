package g;

use v5.24;
use strict;
use warnings;

use Import::Into;

# Can't include bareword::filehandles because this conflicts with autodie -
# see https://rt.cpan.org/Ticket/Display.html?id=93591
use autodie ();
use experimental ();
use feature          ();
use indirect         ();
use mro              ();
use multidimensional ();

# This adds the UTF-8 layer on STDIN, STDOUT, STDERR for _everyone_
use open qw( :encoding(UTF-8) :std );
use utf8 ();

# Copied from strictures.pm
our @WARNING_CATEGORIES = grep { exists $warnings::Offsets{$_} }
#<<<
qw(
  closure
  chmod
  deprecated
  exiting
  experimental
    experimental::autoderef
    experimental::bitwise
    experimental::const_attr
    experimental::lexical_subs
    experimental::lexical_topic
    experimental::postderef
    experimental::re_strict
    experimental::refaliasing
    experimental::regex_sets
    experimental::signatures
    experimental::smartmatch
    experimental::win32_perlio
  glob
  imprecision
  io
    closed
    exec
    layer
    newline
    pipe
    syscalls
    unopened
  locale
  misc
  missing
  numeric
  once
  overflow
  pack
  portable
  recursion
  redefine
  redundant
  regexp
  severe
    debugging
    inplace
    internal
    malloc
  signal
  substr
  syntax
    ambiguous
    bareword
    digit
    illegalproto
    parenthesis
    precedence
    printf
    prototype
    qw
    reserved
    semicolon
  taint
  threads
  uninitialized
  umask
  unpack
  untie
  utf8
    non_unicode
    nonchar
    surrogate
  void
  void_unusual
  y2k
);
#>>>

our @WARNING_NONFATAL = grep { exists $warnings::Offsets{$_} } (
    'exec',            # not safe to catch
    'recursion',       # will be caught by other mechanisms
    'internal',        # not safe to catch
    'malloc',          # not safe to catch
    'newline',         # stat on nonexistent file with a newline in it
    'experimental',    # no reason for these to be fatal
    'deprecated',      # unfortunately can't make these fatal
    'portable',        # everything worked fine here, just may not elsewhere
);

sub import {
    my $caller_level = 1;

    strict->import;
    warnings->import( FATAL    => @WARNING_CATEGORIES );
    warnings->import( NONFATAL => @WARNING_NONFATAL );
    warnings->unimport('experimental::signatures');

    my @experiments = qw(
        signatures
    );
    experimental->import::into( $caller_level, @experiments );

    my ($version) = $^V =~ /^v(5\.\d+)/;
    feature->import::into( $caller_level, ':' . $version );
    mro::set_mro( scalar caller(), 'c3' );
    utf8->import::into($caller_level);

    indirect->unimport::out_of( $caller_level, ':fatal' );
    multidimensional->unimport::out_of($caller_level);
    'open'->import::into( $caller_level, ':encoding(UTF-8)' );
    autodie->import::into( $caller_level, ':all' );
}

1;
