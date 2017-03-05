#!perl

use Test::More;
use strict;
use FindBin qw($Bin);

require "$Bin/helper.pl";

my $version = '0.5';

check_minimum_test_more_version();

subtest 'help works on all subcommands' => sub {
    focus('help');

    my ( $home, $repo ) = minimum_home('help');

    foreach my $command (qw(install mergeandinstall updates)) {
        my $output = `HOME=$home perl $repo/bin/dfm $command --help`;
        like(
            $output,
            qr/Usage.*For full documentation/msi,
            "help ok for subcommand $command"
        );
        like( $output, qr/dfm version $version/msi, "version number ok" );
    }
};

subtest 'version commandline flag' => sub {
    focus('version');

    my ( $home, $repo ) = minimum_home('version');

    my $output = `HOME=$home perl $repo/bin/dfm --version`;
    like( $output, qr/dfm version $version/msi, "version output ok" );
};

done_testing;
