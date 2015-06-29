use strict;
use warnings;

use Test::More;
use Test::Moose::More;

{
    package TR;
    use Moose::Role;
    with 'MooseX::RelatedNamespace';
}
{
    package TC;
    use Moose;
    with 'MooseX::RelatedNamespace';
}

subtest 'structural: composed in role' => sub {
    validate_role TR => (
        attributes => [
            'namespace',
            'modules_in_namespace',
        ],
        methods => [],
    );
};

subtest 'structural: composed in class' => sub {
    validate_class TC => (
        attributes => [
            'namespace',
            'modules_in_namespace',
        ],
        methods => [],
    );
};

subtest 'simple role test' => sub {

    use lib 't/lib';

    my $ns = 'NS::One';
    #my $c = TC->new(namespace => 'NS::One');
    #isa_ok $c, 'TC';

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
};

done_testing;
