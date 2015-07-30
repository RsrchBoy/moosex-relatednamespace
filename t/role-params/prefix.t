use strict;
use warnings;

use Test::More;
use Test::Moose::More 0.033;

{
    package TC;
    use Moose;
    with 'MooseX::RelatedNamespace' => {
        prefix => 'doctor',
    };
}

validate_class TC => (
    attributes => [
        doctor_namespace            => { is => 'ro', lazy => 1, builder => '_build_doctor_namespace' },
        modules_in_doctor_namespace => { is => 'ro' },
        filter_for_doctor_namespace => { is => 'ro', lazy => 1, isa => 'CodeRef' },
    ],
    methods => [
        qw{ doctor_namespace modules_in_doctor_namespace filter_for_doctor_namespace },
        qw{ _build_modules_in_doctor_namespace _build_filter_for_doctor_namespace },
    ]
);

done_testing;
