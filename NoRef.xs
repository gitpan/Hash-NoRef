#ifdef __cplusplus
extern "C" {
#endif
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#ifdef __cplusplus
}
#endif


MODULE = Hash::NoRef		PACKAGE = Hash::NoRef


# usage: SvREFCNT(\$var) ;

I32
SvREFCNT(sv)
SV *	sv
 CODE:
	if ( SvROK(sv) ) {
	  sv = (SV*)SvRV(sv);
	  RETVAL = SvREFCNT(sv) - 1 ;
    }
    else { RETVAL = -1 ;}
 OUTPUT:
    RETVAL




# usage: SvREFCNT_inc(\$var) ;
#        PPCODE needed since otherwise sv_2mortal is inserted that will kill
#        the value.


SV *
SvREFCNT_inc(sv)
SV *	sv
 PPCODE:
	if ( SvROK(sv) ) {
	  sv = (SV*)SvRV(sv);
	  RETVAL = SvREFCNT_inc(sv);
	  PUSHs(RETVAL);
    }


# usage: SvREFCNT_dec(\$var) ;
#        PPCODE needed since by default it is void

SV *
SvREFCNT_dec(sv)
SV *	sv
 PPCODE:
	if ( SvROK(sv) ) {
	  sv = (SV*)SvRV(sv);
	  SvREFCNT_dec(sv);
	  PUSHs(sv);
    }



