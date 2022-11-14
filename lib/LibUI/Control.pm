package LibUI::Control 0.01 {
    use 5.008001;
    use strict;
    use warnings;
    use lib '../lib', '../blib/arch', '../blib/lib';
    use Affix;
    use Dyn::Call qw[DC_SIGCHAR_CC_DEFAULT];
    use LibUI;
    $|++;
    #
    {
        typedef 'LibUI::Control' => Struct [
            Signature     => ULong,
            OSSignature   => ULong,
            TypeSignature => ULong,
            Destroy       => CodeRef [ [ InstanceOf ['LibUI::Control'] ] => Void ],
            Handle        =>
                CodeRef [ [ InstanceOf ['LibUI::Control'] ] => InstanceOf ['LibUI::Control'] ],
            Parent =>
                CodeRef [ [ InstanceOf ['LibUI::Control'] ] => InstanceOf ['LibUI::Control'] ],
            SetParent => CodeRef [ [ InstanceOf ['LibUI::Control'] ] => Void ],
            Toplevel  => CodeRef [ [ InstanceOf ['LibUI::Control'] ] => Int ],
            Visible   => CodeRef [ [ InstanceOf ['LibUI::Control'] ] => Int ],
            Show      => CodeRef [ [ InstanceOf ['LibUI::Control'] ] => Void ],
            Hide      => CodeRef [ [ InstanceOf ['LibUI::Control'] ] => Void ],
            Enabled   => CodeRef [ [ InstanceOf ['LibUI::Control'] ] => Int ],
            Enable    => CodeRef [ [ InstanceOf ['LibUI::Control'] ] => Void ],
            Disable   => CodeRef [ [ InstanceOf ['LibUI::Control'] ] => Void ]
        ];
        #
        attach(
            LibUI::lib(),          'uiControlDestroy', [ InstanceOf ['LibUI::Control'] ] => Void,
            DC_SIGCHAR_CC_DEFAULT, 'Destroy'
        );
        attach( LibUI::lib(), 'uiControlHandle',
            [ InstanceOf ['LibUI::Control'] ] => Pointer [UInt] );
        attach( LibUI::lib(), 'uiControlParent',
            [ InstanceOf ['LibUI::Control'] ] => InstanceOf ['LibUI::Control'] );
        attach( LibUI::lib(), 'uiControlSetParent',
            [ InstanceOf ['LibUI::Control'], InstanceOf ['LibUI::Control'] ] => Void );
        attach( LibUI::lib(), 'uiControlToplevel', [ InstanceOf ['LibUI::Control'] ] => Int );
        attach( LibUI::lib(), 'uiControlVisible',  [ InstanceOf ['LibUI::Control'] ] => Int );
        attach(
            LibUI::lib(),          'uiControlShow', [ InstanceOf ['LibUI::Control'] ] => Void,
            DC_SIGCHAR_CC_DEFAULT, 'show'
        );
        attach( LibUI::lib(), 'uiControlHide',    [ InstanceOf ['LibUI::Control'] ] => Void );
        attach( LibUI::lib(), 'uiControlEnabled', [ InstanceOf ['LibUI::Control'] ] => Int );
        attach( LibUI::lib(), 'uiControlEnable',  [ InstanceOf ['LibUI::Control'] ] => Void );
        attach( LibUI::lib(), 'uiControlDisable', [ InstanceOf ['LibUI::Control'] ] => Void );
        attach( LibUI::lib(), 'uiAllocControl',
            [ Size_t, ULong, ULong, Str ] => InstanceOf ['LibUI::Control'] );
        attach( LibUI::lib(), 'uiFreeControl', [ InstanceOf ['LibUI::Control'] ] => Void );
        #
        attach( LibUI::lib(), 'uiControlVerifySetParent',
            [ InstanceOf ['LibUI::Control'], InstanceOf ['LibUI::Control'] ] => Void );
        attach( LibUI::lib(), 'uiControlEnabledToUser', [ InstanceOf ['LibUI::Control'] ] => Int );

# Upstream TODO: Move this to private API? According to old/new.md this should be used by toplevel controls.
        attach( LibUI::lib(), 'uiUserBugCannotSetParentOnToplevel', [Str] => Void );
    }
};
1;
#
__END__

=pod

=encoding utf-8

=head1 NAME

LibUI::Control - Base Class for GUI Controls

=head1 SYNOPSIS

    use LibUI;
    use LibUI::Window;

=head1 DESCRIPTION

A LibUI::Control object represents the superclass for all GUI objects.

=head1 Functions

All subclasses of LibUI::Control have access to these methods.

=head3 C<( ... )>

    my $ctrl = $w->( $w );

Returns




=head1 LICENSE

Copyright (C) Sanko Robinson.

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=head1 AUTHOR

Sanko Robinson E<lt>sanko@cpan.orgE<gt>

=cut

