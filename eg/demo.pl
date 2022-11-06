use strict;
use lib '../lib';
use Affix::libui ':all';
#
my $opts = InitOptions->new( { Size => 1024 } );
uiInit($opts) && die;
my $w = uiNewWindow( "Hi", 320, 240, 0 );
uiWindowSetMargined( $w, 1 );
#
sub onClosing {
    uiQuit();
    return 1;
}
my $b = uiNewVerticalBox();
uiBoxSetPadded( $b, 1 );
uiWindowSetChild( $w, $b );
#
my $e = uiNewMultilineEntry();
uiMultilineEntrySetReadOnly( $e, 1 );
#
my $btn = uiNewButton("Say Something");
uiButtonOnClicked(
    $btn,
    sub {
        uiMultilineEntryAppend( $e, localtime . "\n" );
    },
    undef
);
uiBoxAppend( $b, $btn, 0 );
uiBoxAppend( $b, $e,   1 );
uiWindowOnClosing( $w, \&onClosing, undef );
uiControlShow($w);
uiMain();
exit 0;
