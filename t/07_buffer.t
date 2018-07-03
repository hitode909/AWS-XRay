use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../";

use AWS::XRay::Buffer;
use Test::More;
use IO::Scalar;

subtest "auto_flush=1", sub {
    my $buf;
    my $b = AWS::XRay::Buffer->new(IO::Scalar->new(\$buf), 1);
    $b->print("foo");
    $b->print("bar", "baz");
    is $buf => "foobarbaz";

    $b->print("XXX");
    is $buf => "foobarbazXXX";
};

subtest "auto_flush=0", sub {
    my $buf;
    my $b = AWS::XRay::Buffer->new(IO::Scalar->new(\$buf), 0);
    $b->print("foo");
    $b->print("bar", "baz");
    is $buf => undef;

    $b->flush;
    is $buf => "foobarbaz";

    $b->print("XXX");
    is $buf => "foobarbaz";

    $b->flush;
    is $buf => "foobarbazXXX";
};

done_testing;
