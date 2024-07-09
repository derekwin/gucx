#
# Copyright (c) NVIDIA CORPORATION & AFFILIATES, 2001-2018. ALL RIGHTS RESERVED.
# See file LICENSE for terms.
#

if HAVE_GUCXT

SUBDIRS = .

module_LTLIBRARIES      = libuct_gucxt.la
libuct_gucxt_la_CPPFLAGS = $(BASE_CPPFLAGS) $(GUCXT_CPPFLAGS)
libuct_gucxt_la_CFLAGS   = $(BASE_CFLAGS) $(GUCXT_CFLAGS)
libuct_gucxt_la_LIBADD   = $(top_builddir)/src/ucs/libucs.la \
                          $(top_builddir)/src/uct/libuct.la
libuct_gucxt_la_LDFLAGS  = $(GUCXT_LDFLAGS) $(GUCXT_LIBS) -version-info $(SOVERSION) \
                          $(patsubst %, -Xlinker %, -L$(GUCXT_ROOT)/lib -rpath $(GUCXT_ROOT)/hip/lib -rpath $(GUCXT_ROOT)/lib) \
                          $(patsubst %, -Xlinker %, --enable-new-dtags) \
                          $(patsubst %, -Xlinker %, -rpath $(GUCXT_ROOT)/lib64)

noinst_HEADERS = \
	base/gucxt_md.h \
	base/gucxt_iface.h \
	gucxt_copy/gucxt_copy_md.h \
	gucxt_copy/gucxt_copy_iface.h \
	gucxt_copy/gucxt_copy_ep.h \
	gucxt_ipc/gucxt_ipc_md.h \
	gucxt_ipc/gucxt_ipc_iface.h \
	gucxt_ipc/gucxt_ipc_ep.h \
	gucxt_ipc/gucxt_ipc_cache.h

libuct_gucxt_la_SOURCES = \
	base/gucxt_iface.c \
	base/gucxt_md.c \
	gucxt_copy/gucxt_copy_md.c \
	gucxt_copy/gucxt_copy_iface.c \
	gucxt_copy/gucxt_copy_ep.c \
	gucxt_ipc/gucxt_ipc_md.c \
	gucxt_ipc/gucxt_ipc_iface.c \
	gucxt_ipc/gucxt_ipc_ep.c \
	gucxt_ipc/gucxt_ipc_cache.c

PKG_CONFIG_NAME=gucxt

include $(top_srcdir)/config/module.am
# TODO: enable pkg-config processing when module static build is enabled
# include $(top_srcdir)/config/module-pkg-config.am

endif
