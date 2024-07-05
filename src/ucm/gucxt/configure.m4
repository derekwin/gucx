#
# Copyright (c) NVIDIA CORPORATION & AFFILIATES, 2001-2018. ALL RIGHTS RESERVED.
# Copyright (C) Advanced Micro Devices, Inc. 2019. ALL RIGHTS RESERVED.
#
# See file LICENSE for terms.
#

UCX_CHECK_GUCXT
AS_IF([test "x$gucxt_happy" = "xyes"], [ucm_modules="${ucm_modules}:gucxt"])
AC_CONFIG_FILES([src/ucm/gucxt/Makefile])
