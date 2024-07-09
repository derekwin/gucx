#
# Copyright (c) NVIDIA CORPORATION & AFFILIATES, 2001-2017. ALL RIGHTS RESERVED.
# See file LICENSE for terms.
#

UCX_CHECK_GUCXT

AS_IF([test "x$gucxt_happy" = "xyes"], [uct_modules="${uct_modules}:gucxt"])
uct_gucxt_modules=""
AC_DEFINE_UNQUOTED([uct_gucxt_MODULES], ["${uct_gucxt_modules}"], [GUCXT loadable modules])
AC_CONFIG_FILES([src/uct/gucxt/Makefile
                 src/uct/gucxt/ucx-gucxt.pc])
