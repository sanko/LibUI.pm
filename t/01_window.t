use strict;
use Test::More 0.98;
use lib './t/lib', './lib', '../lib';
use t::Display;
use LibUI ':all';
#
t::Display::needs_display();
uiInit( { Size => 0 } ) && die;
#
pass 'post Init()';
isa_ok my $window = uiNewWindow( 'Hi', 320, 100, 0 ), 'LibUI::Window',
    q[uiNewWindow( 'Hi', 320, 100, 0 )];
uiWindowOnClosing(
    $window,
    sub {
        my ( $w, $arg ) = @_;
        is_deeply \@_, [ $window, 'Quick test' ], 'onClosing(...) callback args';
        diag 'Window closed manually';
        uiQuit();
        return 1;
    },
    'Quick test'
);
ok !uiControlShow($window), 'uiControlShow($window)';
uiTimer(
    100,
    sub {
        pass 'Timer triggered! Quitting...';
        uiControlDestroy($window);
        uiQuit();
    },
    undef
);
uiMain();
uiUninit();
#
done_testing;
