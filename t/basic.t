use strict;
use warnings;

use Test::More;
use Test::Moose::More 0.033;

{ package TR; use Moose::Role; with 'MooseX::RelatedNamespace'; }
{ package TC; use Moose;       with 'MooseX::RelatedNamespace'; }

validate_role TR => (
    -compose => 1,
    attributes => [
        namespace            => { is => 'ro', lazy => 1, builder => '_build_namespace' },
        modules_in_namespace => { is => 'ro' },
        filter_for_namespace => { is => 'ro', lazy => 1, isa => 'CodeRef' },
    ],
);

done_testing;
