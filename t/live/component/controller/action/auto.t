#!perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../../../lib";

use Test::More tests => 180;
use Catalyst::Test 'TestApp';

for ( 1 .. 10 ) {
    # test auto + local method
    {
        my @expected = qw[
          TestApp::Controller::Action::Auto->begin
          TestApp::Controller::Action::Auto->auto
          TestApp::Controller::Action::Auto->one
        ];
    
        my $expected = join( ", ", @expected );
    
        ok( my $response = request('http://localhost/action/auto/one'), 'auto + local' );
        is( $response->header('X-Catalyst-Executed'),
            $expected, 'Executed actions' );
        is( $response->content, 'one', 'Content OK' );
    }
    
    # test auto + default
    {
        my @expected = qw[
          TestApp::Controller::Action::Auto->begin
          TestApp::Controller::Action::Auto->auto
          TestApp::Controller::Action::Auto->default
        ];
    
        my $expected = join( ", ", @expected );
    
        ok( my $response = request('http://localhost/action/auto/anything'), 'auto + default' );
        is( $response->header('X-Catalyst-Executed'),
            $expected, 'Executed actions' );
        is( $response->content, 'default', 'Content OK' );
    }
    
    # test auto + auto + local
    {
        my @expected = qw[
          TestApp::Controller::Action::Auto::Deep->begin
          TestApp::Controller::Action::Auto->auto
          TestApp::Controller::Action::Auto::Deep->auto
          TestApp::Controller::Action::Auto::Deep->one
        ];
    
        my $expected = join( ", ", @expected );
    
        ok( my $response = request('http://localhost/action/auto/deep/one'), 'auto + auto + local' );
        is( $response->header('X-Catalyst-Executed'),
            $expected, 'Executed actions' );
        is( $response->content, 'deep one', 'Content OK' );
    }
    
    # test auto + auto + default
    {
        my @expected = qw[
          TestApp::Controller::Action::Auto::Deep->begin
          TestApp::Controller::Action::Auto->auto
          TestApp::Controller::Action::Auto::Deep->auto
          TestApp::Controller::Action::Auto::Deep->default
        ];
    
        my $expected = join( ", ", @expected );
    
        ok( my $response = request('http://localhost/action/auto/deep/anything'), 'auto + auto + default' );
        is( $response->header('X-Catalyst-Executed'),
            $expected, 'Executed actions' );
        is( $response->content, 'deep default', 'Content OK' );
    }
    
    # test auto + failing auto + local + end
    {
        my @expected = qw[
          TestApp::Controller::Action::Auto::Abort->begin
          TestApp::Controller::Action::Auto->auto
          TestApp::Controller::Action::Auto::Abort->auto
          TestApp::Controller::Action::Auto::Abort->end
        ];
    
        my $expected = join( ", ", @expected );
    
        ok( my $response = request('http://localhost/action/auto/abort/one'), 'auto + failing auto + local' );
        is( $response->header('X-Catalyst-Executed'),
            $expected, 'Executed actions' );
        is( $response->content, 'abort end', 'Content OK' );
    }
    
    # test auto + failing auto + default + end
    {
        my @expected = qw[
          TestApp::Controller::Action::Auto::Abort->begin
          TestApp::Controller::Action::Auto->auto
          TestApp::Controller::Action::Auto::Abort->auto
          TestApp::Controller::Action::Auto::Abort->end
        ];
    
        my $expected = join( ", ", @expected );
    
        ok( my $response = request('http://localhost/action/auto/abort/anything'), 'auto + failing auto + default' );
        is( $response->header('X-Catalyst-Executed'),
            $expected, 'Executed actions' );
        is( $response->content, 'abort end', 'Content OK' );
    }
}
