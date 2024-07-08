#
# Copyright (C) Advanced Micro Devices, Inc. 2019. ALL RIGHTS RESERVED.
#
# See file LICENSE for terms.
#

if HAVE_GUCXT

module_LTLIBRARIES               = libucx_perftest_gucxt.la
libucx_perftest_gucxt_la_CPPFLAGS = $(BASE_CPPFLAGS) $(GUCXT_CPPFLAGS)
libucx_perftest_gucxt_la_CFLAGS   = $(BASE_CFLAGS) $(GUCXT_CFLAGS)
libucx_perftest_gucxt_la_LDFLAGS  = $(GUCXT_LDFLAGS) $(GUCXT_LIBS) -version-info $(SOVERSION) \
                          $(patsubst %, -Xlinker %, -L$(GUCXT_ROOT)/lib -rpath $(GUCXT_ROOT)/lib) \
                          $(patsubst %, -Xlinker %, --enable-new-dtags)

libucx_perftest_gucxt_la_SOURCES  = gucxt_alloc.c

include $(top_srcdir)/config/module.am

endif
