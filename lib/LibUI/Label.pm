package LibUI::Label 0.01 {
    use 5.008001;
    use strict;
    use warnings;
    use Affix;
    use Dyn::Call qw[DC_SIGCHAR_CC_DEFAULT];
    use parent 'LibUI::Control';
    #
    attach(
        LibUI::lib(),          'uiLabelText', [ InstanceOf ['LibUI::Label'] ] => Str,
        DC_SIGCHAR_CC_DEFAULT, 'text'
    );
    attach(
        LibUI::lib(),          'uiLabelSetText', [ InstanceOf ['LibUI::Label'], Str ] => Void,
        DC_SIGCHAR_CC_DEFAULT, 'setText'
    );
    attach(
        LibUI::lib(),          'uiNewLabel', [ Void, Str ] => InstanceOf ['LibUI::Label'],
        DC_SIGCHAR_CC_DEFAULT, 'new'
    );
};
1;
#
__END__

=pod

=encoding utf-8

=head1 NAME

LibUI::Label - Non-interactive Text Display

=head1 SYNOPSIS

    use LibUI ':all';
    use LibUI::Window;
    use LibUI::Label;
    Init( { Size => 1024 } ) && die;
    my $window = LibUI::Window->new( 'Hi', 320, 100, 0 );
    $window->setChild( LibUI::Label->new('Hello, World!') );
    $window->onClosing(
        sub {
            Quit();
            return 1;
        },
        undef
    );
    $window->show;
    Main();

=head1 DESCRIPTION

A LibUI::Label object represents control that displays non-interactive text.

=head1 Functions

Not a lot here but... well, it's just a text label.

=head2 C<new( ... )>

    my $lbl = LibUI::Label->new( 'Working...' );

Creates a new LibUI::Label.

Expected parameters include:

=over

=item C<$text> - label text

=back

=head2 C<text( ... )>

    my $title = $lbl->text( );

Returns the label text.

=head2 C<setText( ... )>

    $lbl->setText( 'Complete' );

Sets the label text.

=head1 LICENSE

Copyright (C) Sanko Robinson.

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=head1 AUTHOR

Sanko Robinson E<lt>sanko@cpan.orgE<gt>

=cut

