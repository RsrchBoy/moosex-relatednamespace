use strict;
use warnings;

use Test::More;
use Test::Moose::More;

{
    package TR;
    use Moose::Role;
    with 'MooseX::RelatedNamespace';
}

validate_role TR => (
    attributes => [
        'namespace',
        'modules_in_namespace',
    ],
    methods => [],
);

done_testing;
