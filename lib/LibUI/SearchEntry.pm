package LibUI::SearchEntry 0.01 {
    use 5.008001;
    use strict;
    use warnings;
    use Affix;
    use Dyn::Call qw[DC_SIGCHAR_CC_DEFAULT];
    use parent 'LibUI::Entry';
    #
    affix(
        LibUI::lib(),          'uiNewSearchEntry', [Void] => InstanceOf ['LibUI::SearchEntry'],
        DC_SIGCHAR_CC_DEFAULT, 'new'
    );
};
1;
#
__END__

=pod

=encoding utf-8

=head1 NAME

LibUI::Entry - Single Line Text Entry Field Suitable for Sensitive Input

=head1 SYNOPSIS

    use LibUI ':all';
    use LibUI::VBox;
    use LibUI::Window;
    use LibUI::SearchEntry;
    Init( { Size => 1024 } ) && die;
    my $window = LibUI::Window->new( 'Hi', 320, 100, 0 );
    my $box    = LibUI::VBox->new();
    my $pass   = LibUI::SearchEntry->new;
    $box->append( $pass, 0 );
    $pass->onChanged( sub { warn 'Query: ' . shift->text }, undef );
    $window->setChild($box);
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

A LibUI::SearchEntry object represents a control with a single line text entry
field.

Some systems will deliberately delay the C<onChanged( ... )> callback for a
more natural feel.

This is a subclass of L<LibUI::Entry>.

=head1 Functions

Not a lot here but... well, it's just a text box.

=head2 C<new( ... )>

    my $txt = LibUI::SearchEntry->new( );

Creates a new entry.

=head2 C<onChanged( ... )>

    $txt->onChanged(
    sub {
        my ($ctrl, $data) = @_;
        warn $ctrl->text;
    }, undef);

Registers a callback for when the user changes the entry's text.

Expected parameters include:

=over

=item C<$callback> - CodeRef that should expect the following:

=over

=item C<$txt> - backreference to the instance that initiated the callback

=item C<$data> - user data registered with the sender instance

=back

=item C<$data> - user data to be passed to the callback

=back

Note: The callback is not triggered when calling C<setText( ... )>.

=head2 C<readonly( ... )>

    if( $txt->readonly( ) ) {
        ...;
    }

Returns whether or not the entry's text can be changed.

=head2 C<setReadonly( ... )>

    $txt->setReadonly( 1 );

Sets whether or not the entry's text is read only.

=head2 C<setText( ... )>

    $txt->setText( 'Updated' );

Sets the entry's text.

=head2 C<text( ... )>

    warn $txt->text( );

Returns the entry's text.

=head1 LICENSE

Copyright (C) Sanko Robinson.

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=head1 AUTHOR

Sanko Robinson E<lt>sanko@cpan.orgE<gt>

=cut

