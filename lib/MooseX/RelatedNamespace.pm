package MooseX::RelatedNamespace;

# ABSTRACT: The great new MooseX::RelatedNamespace!

use MooseX::Role::Parameterized;
use namespace::autoclean 0.24;
use MooseX::AttributeShortcuts;

use MooseX::Types::Moose ':all';
use MooseX::Types::Perl  ':all';

=roleparam prefix

A prefix for our attribute names; e.g. 'doctor_' to make our namespace
attribute's name be 'doctor_namespace', etc.

=cut

parameter prefix => (
    is      => 'ro',
    isa     => Str,
    default => q{},
);

=roleparam default_namespace

If we should have a default namespace, specify it here.

=cut

parameter default_namespace => (
    traits    => [Shortcuts],
    isa       => PackageName,
    required  => 0,
    predicate => 1,
);

=roleparam filter

A coderef used to filter out modules found under the namespace; it should return true for
modules to keep, false for modules to drop.

=cut

parameter filter => (
    traits  => [Shortcuts],
    isa     => CodeRef,
    default => sub { sub { 1 } },
);

=attr namespace

The namespace we use to find packages; e.g. 'TimeLord::Doctor' to find
'TimeLord::Doctor::First', etc.

=attr modules_in_namespace

The (filtered) list of modules in the namespace.  Lazily generated.

=cut

role {
    my ($p, %opts) = @_;

    use MooseX::Types::LoadableClass ':all';
    use MooseX::Types::Moose         ':all';
    use MooseX::Types::Perl          ':all';

    use Module::Find;

    my $prefix = $p->prefix;
    $prefix .= '_' if $prefix ne q{};

    # attribute names -- the better to not repeat ourselves
    my $ns_attribute       = "${prefix}namespace";
    my $all_mods_attribute = "modules_in_${prefix}namespace";

    has $ns_attribute => (
        is  => 'lazy',
        isa => PackageName,
        ( $p->has_default_namespace
            ? (builder  => sub { $p->default_namespace })
            : (required => 1)
        ),
    );

    has $all_mods_attribute => (
        is      => 'lazy',
        isa     => ArrayRef[PackageName],
        builder => sub{
            my $self = shift @_;

            # find/use all packages in namespace; then filter
            my @mods = sort
                grep { $p->filter->($_) }
                Module::Find::useall($self->$ns_attribute())
            ;

            ### @mods
            return \@mods;
        },
    );
};

!!42;
__END__

=head1 SYNOPSIS

    package Dalek::Enemies;

    use Moose;

    # this...
    with 'MooseX::RelatedNamespace' => {
        prefix    => 'doctor',
        namespace => 'TimeLords::Doctor',
    };

    # ...is the same as:
    use MooseX::AttributeShortcuts; # for these attributes, at any rate
    use MooseX::Types::Perl ':all';

    has doctor_namespace => (
        is  => 'lazy',
        isa => PackageName,
        builder => sub { 'TimeLords::Doctor' },
    );

    has modules_in_doctor_namespace => (
        is      => 'lazy',
        isa     => ArrayRef[PackageName],
        builder => sub { ... },
    );

=head1 DESCRIPTION

=head1 SEE ALSO

=cut
