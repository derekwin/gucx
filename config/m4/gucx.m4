AC_DEFUN([UCX_CHECK_GUCXT],[

AS_IF([test "x$gucxt_checked" != "xyes"],
   [
    AC_ARG_WITH([gucxt],
                [AS_HELP_STRING([--with-gucxt=(DIR)], [Enable the use of GUCXT (default is guess).])],
                [], [with_gucxt=guess])

    AS_IF([test "x$with_gucxt" = "xno"],
        [
         gucxt_happy=no
         have_gucxt_static=no
        ],
        [
         save_CPPFLAGS="$CPPFLAGS"
         save_LDFLAGS="$LDFLAGS"
         save_LIBS="$LIBS"

         GUCXT_CPPFLAGS=""
         GUCXT_LDFLAGS=""
         GUCXT_LIBS=""
         GUCXTRT_LIBS=""
         GUCXTRT_STATIC_LIBS=""
         NVML_LIBS=""

         AS_IF([test ! -z "$with_gucxt" -a "x$with_gucxt" != "xyes" -a "x$with_gucxt" != "xguess"],
               [ucx_check_gucxt_dir="$with_gucxt"
                AS_IF([test -d "$with_gucxt/lib64"], [libsuff="64"], [libsuff=""])
                ucx_check_gucxt_libdir="$with_gucxt/lib$libsuff"
                GUCXT_CPPFLAGS="-I$with_gucxt/include"
                GUCXT_LDFLAGS="-L$ucx_check_gucxt_libdir -L$ucx_check_gucxt_libdir/stubs"])

         CPPFLAGS="$CPPFLAGS $GUCXT_CPPFLAGS"
         LDFLAGS="$LDFLAGS $GUCXT_LDFLAGS"

         # Check gucxt header files
         AC_CHECK_HEADERS([gucxt.h],
                          [gucxt_happy="yes"], [gucxt_happy="no"])

         # Check gucxt libraries
         AS_IF([test "x$gucxt_happy" = "xyes"],
               [AC_CHECK_LIB([gucxt], [cuDeviceGetUuid], // gucxt note
                             [GUCXT_LIBS="$GUCXT_LIBS -lgucxt"], [gucxt_happy="no"])])
         AS_IF([test "x$gucxt_happy" = "xyes"],
               [AC_CHECK_LIB([gucxtrt], [gucxtGetDeviceCount], // gucxt note
                             [GUCXTRT_LIBS="$GUCXTRT_LIBS -lgucxtrt"], [gucxt_happy="no"])])

         # Check for gucxt static library
         have_gucxt_static="no"
         AS_IF([test "x$gucxt_happy" = "xyes"],
               [AC_CHECK_LIB([gucxtrt_static], [gucxtGetDeviceCount],
                             [GUCXTRT_STATIC_LIBS="$GUCXTRT_STATIC_LIBS -lgucxtrt_static -lrt -ldl -lpthread"
                              have_gucxt_static="yes"],
                             [], [-ldl -lrt -lpthread])])

         CPPFLAGS="$save_CPPFLAGS"
         LDFLAGS="$save_LDFLAGS"
         LIBS="$save_LIBS"

         AS_IF([test "x$gucxt_happy" = "xyes"],
               [AC_SUBST([GUCXT_CPPFLAGS], ["$GUCXT_CPPFLAGS"])
                AC_SUBST([GUCXT_LDFLAGS], ["$GUCXT_LDFLAGS"])
                AC_SUBST([GUCXT_LIBS], ["$GUCXT_LIBS"])
                AC_SUBST([GUCXTRT_LIBS], ["$GUCXTRT_LIBS"])
                AC_SUBST([GUCXTRT_STATIC_LIBS], ["$GUCXTRT_STATIC_LIBS"])
                AC_DEFINE([HAVE_GUCXT], 1, [Enable GUCXT support])],
               [AS_IF([test "x$with_gucxt" != "xguess"],
                      [AC_MSG_ERROR([GUCXT support is requested but gucxt packages cannot be found])],
                      [AC_MSG_WARN([GUCXT not found])])])

        ]) # "x$with_gucxt" = "xno"

        gucxt_checked=yes
        AM_CONDITIONAL([HAVE_GUCXT], [test "x$gucxt_happy" != xno])
        AM_CONDITIONAL([HAVE_GUCXT_STATIC], [test "X$have_gucxt_static" = "Xyes"])

   ]) # "x$gucxt_checked" != "xyes"

]) # UCX_CHECK_GUCXT
