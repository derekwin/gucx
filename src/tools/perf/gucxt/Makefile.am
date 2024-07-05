#
# Copyright (C) Advanced Micro Devices, Inc. 2019. ALL RIGHTS RESERVED.
#
# See file LICENSE for terms.
#

if HAVE_GUCXT

module_LTLIBRARIES               = libucx_perftest_guctx.la
libucx_perftest_guctx_la_CPPFLAGS = $(BASE_CPPFLAGS) $(HIP_CPPFLAGS)
libucx_perftest_guctx_la_CFLAGS   = $(BASE_CFLAGS) $(HIP_CFLAGS)
libucx_perftest_guctx_la_LDFLAGS  = $(HIP_LDFLAGS) $(HIP_LIBS) -version-info $(SOVERSION) \
                          $(patsubst %, -Xlinker %, -L$(GUCXT_ROOT)/lib -rpath $(GUCXT_ROOT)/hip/lib -rpath $(GUCXT_ROOT)/lib) \
                          $(patsubst %, -Xlinker %, --enable-new-dtags) \
                          $(patsubst %, -Xlinker %, -rpath $(GUCXT_ROOT)/lib64)
libucx_perftest_guctx_la_SOURCES  = guctx_alloc.c

include $(top_srcdir)/config/module.am

endif
