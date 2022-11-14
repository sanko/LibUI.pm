use strict;
use warnings;
use lib '../lib';
use Affix;
use Data::Dump;
#
{
    use LibUI ':all';
    use LibUI::Form;
    use LibUI::Window;
    use LibUI::ColorButton;
    Init( { Size => 1024 } ) && die;
    my $window = LibUI::Window->new( 'Hi', 320, 100, 0 );
    my $form   = LibUI::Form->new();
    my $cbtn_l = LibUI::ColorButton->new();
    my $cbtn_r = LibUI::ColorButton->new();

    sub colorChanged {
        warn sprintf '%5s #%02X%02X%02X%02X', pop, map { $_ * 255 } shift->color();
    }
    $cbtn_l->onChanged( \&colorChanged, 'Left' );
    $cbtn_r->onChanged( \&colorChanged, 'Right' );
    $form->append( 'Left',  $cbtn_l, 0 );
    $form->append( 'Right', $cbtn_r, 0 );
    $form->setPadded(1);
    $window->setChild($form);
    $window->onClosing(
        sub {
            Quit();
            return 1;
        },
        undef
    );
    $window->show;
    Main();
}
__END__
my $menu = LibUI::Menu->new("Fun");
MenuAppendItem( $menu, "Hi" );
MenuAppendQuitItem($menu);
OnShouldQuit( sub { warn 'hi'; }, undef );
ddx $opts;
my $w = NewWindow( "Hi", 320, 240, 1 );
WindowSetMargined( $w, 1 );
#
sub onClosing {
    Quit();
    return 1;
}
my $b = NewVerticalBox();
BoxSetPadded( $b, 1 );
WindowSetChild( $w, $b );
ddx $menu;
warn $menu;
#
#
my $e = NewMultilineEntry();
MultilineEntrySetReadOnly( $e, 1 );
#
my $btn = NewButton('Clear!');
{
    ButtonOnClicked(
        $btn,
        sub {
            my ( $b, $data ) = @_;
            warn 'Click';

            #uiMultilineEntrySetText( $e, '' );
        },
        undef
    );
}
BoxAppend( $b, $e, 1 );
ddx ControlParent($e);
BoxAppend( $b, $btn, 0 );
my $prog = NewProgressBar();
BoxAppend( $b, $prog, 0 );
my $dt = NewDatePicker();
BoxAppend( $b, $dt, 0 );
DateTimePickerOnChanged(
    $dt,
    sub {
        DateTimePickerTime( $dt, my $ptr );
        ddx $ptr;
    }
);
WindowOnClosing( $w, \&onClosing, undef );
{
    Timer(
        1000,
        sub ($) {
            MultilineEntryAppend( $e, sprintf "[%04d] %s\n", $_[0]++, scalar localtime );
            return 1;    # Keep going
        },
        my $s = 0
    );
}
{
    Timer(
        10,
        sub {
            ProgressBarSetValue( $prog, ++$_[0] % 100 );
            return 1;    # Keep going
        },
        my $s = 0
    );
}
{
    my ( $w_, $h_ );
    WindowContentSize( $w, $w_, $h_ );
    warn sprintf 'Window size: %d * %d', $w_, $h_;
}
ControlShow($w);
Main();
