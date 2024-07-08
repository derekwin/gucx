#
# Copyright (C) Advanced Micro Devices, Inc. 2019.  ALL RIGHTS RESERVED.
#
# See file LICENSE for terms.
#

UCX_CHECK_GUCXT

AS_IF([test "x$gucxt_happy" = "xyes"], [ucx_perftest_modules="${ucx_perftest_modules}:gucxt"])

AC_CONFIG_FILES([src/tools/perf/gucxt/Makefile])
