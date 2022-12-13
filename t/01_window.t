use strict;
use Test::More 0.98;
use Test::NeedsDisplay;
use lib '../lib';
use LibUI ':all';
use LibUI::Window;
Init( { Size => 1024 } ) && die;
my $window = LibUI::Window->new( 'Hi', 320, 100, 0 );
isa_ok $window, 'LibUI::Window';
$window->onClosing(
    sub {
        diag 'Window cloased manually';
        Quit();
        return 1;
    },
    undef
);
ok !$window->show, '->show';
Timer(
    10,
    sub {
        pass 'Timer triggered! Quitting...';
        Quit;
    },
    undef
);
Main();
done_testing
