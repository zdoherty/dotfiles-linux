#!perl

use Test::More;
use strict;
use FindBin qw($Bin);
use English qw( -no_match_vars );

require "$Bin/helper.pl";

my $file_slurp_available = load_mod('File::Slurp qw(read_file)');

check_minimum_test_more_version();

my $profile_filename = ( lc($OSNAME) eq 'darwin' ) ? '.profile' : '.bashrc';

subtest 'updates and mergeandinstall' => sub {
    focus('up_mi');

    my ( $home, $repo, $origin ) = minimum_home('host1');
    my ( $home2, $repo2 ) = minimum_home( 'host2', { origin => $origin } );

    add_file_and_push( $home, $repo );

    my $output;

    $output = `HOME=$home2 perl $repo2/bin/dfm updates 2> /dev/null`;
    like( $output, qr/adding \.testfile/, 'message in output' );
    ok( !-e "$repo2/.testfile", 'updated file is not there' );

    # remove the origin repo, to make sure that --no-fetch
    # still works (because the updates are already local,
    # --no-fetch doesn't refetch)
    `rm -rf $origin`;
    $output
        = `HOME=$home2 perl $repo2/bin/dfm updates --no-fetch 2> /dev/null`;
    like( $output, qr/adding \.testfile/, 'message in output' );
    ok( !-e "$repo2/.testfile", 'updated file is not there' );

    $output = `HOME=$home2 perl $repo2/bin/dfm mi 2> /dev/null`;
    like( $output, qr/\.testfile/, 'message in output' );
    ok( -e "$repo2/.testfile", 'updated file is there' );
    ok( -l "$home2/.testfile", 'updated file is installed' );
};

# identical to above, with spaces
subtest 'spaces in username' => sub {
    focus('mi_spaces_in_username');

    my ( $home, $repo, $origin ) = minimum_home('host one');
    my ( $home2, $repo2 ) = minimum_home( 'host two', { origin => $origin } );

    add_file_and_push( $home, $repo );

    my $output;

    $output = `HOME='$home2' perl '$repo2/bin/dfm' updates 2> /dev/null`;

    like( $output, qr/adding \.testfile/, 'message in output' );
    ok( !-e "$repo2/.testfile", 'updated file is not there' );

    # remove the origin repo, to make sure that --no-fetch
    # still works (because the updates are already local,
    # --no-fetch doesn't refetch)
    `rm -rf '$origin'`;
    $output
        = `HOME='$home2' perl '$repo2/bin/dfm' updates --no-fetch 2> /dev/null`;
    like( $output, qr/adding \.testfile/, 'message in output' );
    ok( !-e "$repo2/.testfile", 'updated file is not there' );

    $output = `HOME='$home2' perl '$repo2/bin/dfm' mi 2> /dev/null`;
    like( $output, qr/\.testfile/, 'message in output' );
    ok( -e "$repo2/.testfile", 'updated file is there' );
    ok( -l "$home2/.testfile", 'updated file is installed' );
};

subtest 'modifications in two repos, rebase' => sub {
    focus('rebase');

    my ( $home, $repo, $origin ) = minimum_home('host1_rebase');
    my ( $home2, $repo2 )
        = minimum_home( 'host2_rebase', { origin => $origin } );

    add_file_and_push( $home, $repo );
    add_file( $home2, $repo2, '.otherfile' );

    my $output;

    $output = `HOME=$home2 perl $repo2/bin/dfm updates 2> /dev/null`;

    like( $output, qr/adding \.testfile/, 'message in output' );
    ok( !-e "$repo2/.testfile", 'updated file is not there' );

    $output = `HOME=$home2 perl $repo2/bin/dfm mi 2> /dev/null`;
    like( $output, qr/local changes detected/, 'conflict message in output' );
    ok( !-e "$repo2/.testfile", 'updated file is still not there' );

    $output = `HOME=$home2 perl $repo2/bin/dfm mi --rebase 2> /dev/null`;
    like(
        $output,
        qr/rewinding head to replay/,
        'git rebase info message seen'
    );
    ok( -e "$repo2/.testfile", 'updated file is there' );
    ok( -l "$home2/.testfile", 'updated file is installed' );

    $output = `HOME=$home2 perl $repo2/bin/dfm log 2> /dev/null`;
    unlike(
        $output,
        qr/Merge remote-tracking branch 'origin\/master'/,
        'no git merge log message seen'
    );
};

subtest 'modifications in two repos, merge' => sub {
    focus('merge');

    my ( $home, $repo, $origin ) = minimum_home('host1_merge');
    my ( $home2, $repo2 )
        = minimum_home( 'host2_merge', { origin => $origin } );

    add_file_and_push( $home, $repo );
    add_file( $home2, $repo2, '.otherfile' );

    my $output;

    $output = `HOME=$home2 perl $repo2/bin/dfm updates 2> /dev/null`;

    like( $output, qr/adding \.testfile/, 'message in output' );
    ok( !-e "$repo2/.testfile", 'updated file is not there' );

    $output = `HOME=$home2 perl $repo2/bin/dfm mi 2> /dev/null`;
    like( $output, qr/local changes detected/, 'conflict message in output' );
    ok( !-e "$repo2/.testfile", 'updated file is still not there' );

    $output = `HOME=$home2 perl $repo2/bin/dfm mi --merge 2> /dev/null`;
    like( $output, qr/merge made.*recursive/i,
        'git merge info message seen' );
    ok( -e "$repo2/.testfile", 'updated file is there' );
    ok( -l "$home2/.testfile", 'updated file is installed' );

    $output = `HOME=$home2 perl $repo2/bin/dfm log 2> /dev/null`;
    like(
        $output,
        qr/Merge remote(-tracking)? branch 'origin\/master'/,
        'git merge log message seen'
    );
};

subtest 'umi' => sub {
    focus('umi');

    my ( $home, $repo, $origin ) = minimum_home('host1');
    my ( $home2, $repo2 ) = minimum_home( 'host2', { origin => $origin } );

    add_file_and_push( $home, $repo );

    my $output;

    $output = `HOME=$home2 perl $repo2/bin/dfm umi 2> /dev/null`;
    like( $output, qr/adding \.testfile/, 'message in output' );
    like( $output, qr/\.testfile/,        'message in output' );
    ok( -e "$repo2/.testfile", 'updated file is there' );
    ok( -l "$home2/.testfile", 'updated file is installed' );
};

subtest 'non origin remote' => sub {
    focus('non_origin');

    my ( $home,  $repo,  $origin )  = minimum_home('host1');
    my ( $home2, $repo2, $origin2 ) = minimum_home('host2');

    # first, make a personal branch in repo 1, and add a new file
    `HOME=$home perl $repo/bin/dfm checkout -b personal`;
    add_file( $home, $repo, 'testfile' );
    `HOME=$home perl $repo/bin/dfm push origin personal 2> /dev/null`;

    # on the second host, add the first as a remote
    # and install from the personal branch
    `HOME=$home2 perl $repo2/bin/dfm remote add upstream $origin`;
    `HOME=$home2 perl $repo2/bin/dfm fetch upstream`;
    `HOME=$home2 perl $repo2/bin/dfm checkout -b personal upstream/personal`;
    `HOME=$home2 perl $repo2/bin/dfm install`;

    # next, make a change in the first, on the personal branch
    add_file( $home, $repo, 'testfile2', 'contents2' );
    `HOME=$home perl $repo/bin/dfm push origin personal 2> /dev/null`;

    # and finally, run updates to make sure we can pull
    # from the non-origin upstream
    my $output = `HOME=$home2 perl $repo2/bin/dfm updates 2> /dev/null`;
    like( $output, qr/adding testfile2/, 'message in output' );
};

subtest 'non origin remote different name' => sub {
    focus('non_origin_diff_name');

    my ( $home,  $repo,  $origin )  = minimum_home('host1');
    my ( $home2, $repo2, $origin2 ) = minimum_home('host2');

    # first, make a personal branch in repo 1, and add a new file
    `HOME=$home perl $repo/bin/dfm checkout -b personal`;
    add_file( $home, $repo, 'testfile' );
    `HOME=$home perl $repo/bin/dfm push origin personal 2> /dev/null`;

    # on the second host, add the first as a remote
    # and install from the personal branch
    `HOME=$home2 perl $repo2/bin/dfm remote add upstream $origin`;
    `HOME=$home2 perl $repo2/bin/dfm fetch upstream`;
    `HOME=$home2 perl $repo2/bin/dfm checkout -b business upstream/personal`;
    `HOME=$home2 perl $repo2/bin/dfm install`;

    # next, make a change in the first, on the personal branch
    add_file( $home, $repo, 'testfile2', 'contents2' );
    `HOME=$home perl $repo/bin/dfm push origin personal 2> /dev/null`;

    # and finally, run updates to make sure we can pull
    # from the non-origin upstream
    my $output = `HOME=$home2 perl $repo2/bin/dfm updates 2> /dev/null`;
    diag($output);
    like( $output, qr/adding testfile2/, 'message in output' );
};

subtest 'check remote branch' => sub {
    focus('check_remote');

    my ( $home, $repo, $origin ) = minimum_home('host1');

    # first, make a personal branch in repo 1, and add a new file
    `HOME=$home perl $repo/bin/dfm checkout -b personal`;
    my $output = `HOME=$home perl $repo/bin/dfm updates 2> /dev/null`;

    ok( $? >> 8 > 0, 'updates throws non-zero exit code' );
    like(
        $output,
        qr/no remote found for branch personal/,
        '"no remote" message in output'
    );

    $output = `HOME=$home perl $repo/bin/dfm mergeandinstall 2> /dev/null`;

    ok( $? >> 8 > 0, 'mergeandinstall throws non-zero exit code' );
    like(
        $output,
        qr/no remote found for branch personal/,
        '"no remote" message in output'
    );
};

done_testing;

sub add_file_and_push {
    my $home = shift || die;
    my $repo = shift || die;
    my $filename = shift;
    my $contents = shift;

    add_file( $home, $repo, $filename, $contents );

    chdir($home);
    `HOME='$home' perl '$repo/bin/dfm' push origin master 2> /dev/null`;
    chdir($Bin);
}

sub add_file {
    my $home     = shift || die;
    my $repo     = shift || die;
    my $filename = shift || '.testfile';
    my $contents = shift || 'contents';

    chdir($home);
    `echo '$contents' > '$filename'`;
    `mv $filename '$repo/$filename'`;
    `HOME='$home' perl '$repo/bin/dfm' add '$filename'`;
    `HOME='$home' perl '$repo/bin/dfm' commit -m 'adding $filename'`;
    chdir($Bin);
}
