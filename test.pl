#########################

###use Data::Dumper ; print Dumper(  ) ;

use Test;
BEGIN { plan tests => 1 } ;

use Hash::NoRef ;

use strict ;
use warnings qw'all' ;

#########################
{

  my $hash = new Hash::NoRef() ;
 
  my $var = 123 ;

  my $ref = \$var ;

  $hash->{var} = $ref ;
  
  ok( ${$hash->{var}} , 123 ) ;
  
  my $refcnt = Hash::NoRef::SvREFCNT( $ref ) ;
  
  ok($refcnt , 1) ;
  
  $hash->{var2} = $ref ;
  
  ok( ${$hash->{var2}} , 123 ) ;
  
  $refcnt = Hash::NoRef::SvREFCNT( $ref ) ;
  
  ok($refcnt , 1) ;
  
  my $hash2 = new Hash::NoRef() ;
  
  $hash2->{hash} = $hash ;
  
  $refcnt = Hash::NoRef::SvREFCNT( $hash ) ;
  
  ok($refcnt , 0) ;
  
  my $hold = $hash ;
  
  $refcnt = Hash::NoRef::SvREFCNT( $hash ) ;
  
  ok($refcnt , 1) ;
  
  $ref = undef ;
  
  ok( ${$hash->{var}} , undef ) ;

}
#########################

print "\nThe End! By!\n" ;

1 ;
