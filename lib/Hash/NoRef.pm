#############################################################################
## Name:        NoRef.pm
## Purpose:     Hash::NoRef
## Author:      Graciliano M. P. 
## Modified by:
## Created:     2004-04-16
## RCS-ID:      
## Copyright:   (c) 2004 Graciliano M. P. 
## Licence:     This program is free software; you can redistribute it and/or
##              modify it under the same terms as Perl itself
#############################################################################

package Hash::NoRef ;
use 5.006 ;

use strict qw(vars);

use vars qw($VERSION @ISA) ;

$VERSION = '0.01' ;

use DynaLoader ;
@ISA = qw(DynaLoader) ;
bootstrap Hash::NoRef $VERSION ;

sub new {
  my %hash ;
  tie(%hash , 'Hash::NoRef') ;
  return \%hash ;
}

sub TIEHASH {
  my $class = shift ;
  my $this = bless({} , $class) ;
  return $this ;
}

sub FETCH {
  my $this = shift ;
  my $k = shift ;

  if ( Hash::NoRef::SvREFCNT( $this->{$k} ) < 1 ) { return ;}
  
  return $this->{$k} ;
}

sub STORE {
  my $this = shift ;
  my $k = shift ;
  
  $this->{$k} = $_[0] ;

  if ( ref($_[0]) ) { Hash::NoRef::SvREFCNT_dec($_[0]) ;}

  return $this->{$k} ;
}

sub EXISTS {
  my $this = shift ;
  my $k = shift ;
  return exists $this->{$k} ;
}

sub DELETE {
  my $this = shift ;
  my $k = shift ;
  return delete $this->{$k} ;
}

sub CLEAR {
  my $this = shift ;
  return %{$this} = () ;
}

sub FIRSTKEY {
  my $this = shift ;
  my $tmp = keys %{$this} ;
  each %{$this} ;
}

sub NEXTKEY {
  my $this = shift ;
  each %{$this} ;
}

sub UNTIE { &DESTROY }

sub DESTROY {
  my $this = shift ;
  
  no warnings ;
  
  foreach my $k ( keys %{$this} ) {
    if ( Hash::NoRef::SvREFCNT( $this->{$k} ) > 0 && ref( $this->{$k} ) ) {
      Hash::NoRef::SvREFCNT_inc( $this->{$k} ) ;
    }
  }
  
  %{$this} = () ;
  
  return ;
}

#######
# END #
#######

1;


__END__

=head1 NAME

Hash::NoRef - A HASH that store values without increse the reference count.

=head1 DESCRIPTION

This HASH will store it's values without increse the reference count.
This can be used to store objects but without interfere in the DESTROY mechanism, since the
reference in this HASH won't count.

=head1 USAGE

  use Hash::NoRef ;

  my $hash = new Hash::NoRef() ;
  
  {
    my $obj = new FOO() ;
    $hash->{obj} = $obj ;
    ## When we exit this block $obj will be destroied,
    ## even with it stored in $hash->{obj}
  }

=head1 FUNTIONS

=head2 SvREFCNT ( REF )

Return the reference count of a reference.
If a reference is not paste it will return -1.
Dead references will return 0.

Note that internally we make -1 to the reference count:

  RETVAL = SvREFCNT(sv) - 1 ;

Since when we make \$var we are actually creating a reference.
So, for objects or reference to anonymous SCALAR, ARRAY, HASH, it will return 0.
To avoid that alwasy paste creating a reference:

  my $hash = {} ;
  print Hash::NoRef::SvREFCNT( $hash ) ; ## returns 0
  print Hash::NoRef::SvREFCNT( \%$hash ) ; ## returns 1

=head2 SvREFCNT_inc ( REF )

Increase the reference count.

=head2 SvREFCNT_dec ( REF )

Decrease the reference count.

=head2 EXAMPLES

  my $var = 123 ;
  $refcnt = Hash::NoRef::SvREFCNT( \$var ) ; ## returns 1
  
  Hash::NoRef::SvREFCNT_inc(\$var) ; ## adda fake reference, so, it will never die.
  Hash::NoRef::SvREFCNT_dec(\$var) ; ## get back to the normal reference count.

=head1 SEE ALSO

L<Spy>, L<Devel::Peek>, L<Safe::World>.

=head1 AUTHOR

Graciliano M. P. <gm@virtuasites.com.br>

I will appreciate any type of feedback (include your opinions and/or suggestions). ;-P

=head1 COPYRIGHT

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut

