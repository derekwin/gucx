#
# Copyright (c) NVIDIA CORPORATION & AFFILIATES, 2001-2018. ALL RIGHTS RESERVED.
# Copyright (C) Advanced Micro Devices, Inc. 2019. ALL RIGHTS RESERVED.
#
# See file LICENSE for terms.
#

if HAVE_GUCXT

module_LTLIBRARIES      = libucm_gucxt.la
libucm_gucxt_la_CPPFLAGS = $(BASE_CPPFLAGS) $(GUCXT_CPPFLAGS)
libucm_gucxt_la_CFLAGS   = $(BASE_CFLAGS) $(GUCXT_CFLAGS)
libucm_gucxt_la_LIBADD   = ../libucm.la
libucm_gucxt_la_LDFLAGS  = $(UCM_MODULE_LDFLAGS) \
                          $(GUCXT_LDFLAGS) $(GUCXT_LIBS) -version-info $(SOVERSION) \
                          $(patsubst %, -Xlinker %, -L$(GUCXT_ROOT)/lib -rpath $(GUCXT_ROOT)/hip/lib -rpath $(GUCXT_ROOT)/lib) \
                          $(patsubst %, -Xlinker %, --enable-new-dtags) \
                          $(patsubst %, -Xlinker %, -rpath $(GUCXT_ROOT)/lib64)

noinst_HEADERS = \
	gucxtmem.h

libucm_gucxt_la_SOURCES = \
	gucxtmem.c

include $(top_srcdir)/config/module.am

endif
