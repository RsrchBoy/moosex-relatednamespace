use strict;
use warnings;

use Test::More;
use Test::Moose::More 0.033;

use lib 't/lib';

{ package TC; use Moose; with 'MooseX::RelatedNamespace'; }

my $ns = 'NS::One';

subtest 'attribute: modules_in_namespace' => sub {

    my $c = TC->new(namespace => $ns);
    is_deeply
        $c->modules_in_namespace,
        [ sort map { "${ns}::$_" } qw{ A B C } ],
        'found all our modules in namespace...',
    ;

};

subtest 'filter modules' => sub {

    my $c = TC->new(
        namespace => $ns,
        filter_for_namespace => sub { $_[0] ne "${ns}::B" },
    );
    is_deeply
        $c->modules_in_namespace,
        [ sort map { "${ns}::$_" } qw{ A C } ],
        'found all our modules in namespace...',
    ;

};

done_testing;
