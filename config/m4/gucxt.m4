AC_DEFUN([UCX_CHECK_GUCXT],[

AS_IF([test "x$gucxt_checked" != "xyes"],
   [
    AC_ARG_WITH([gucxt],
                [AS_HELP_STRING([--with-gucxt=(DIR)], [Enable the use of GUCXT (default is guess).])],
                [], [with_gucxt=guess])

    AS_IF([test "x$with_gucxt" = "xno"],
        [
         gucxt_happy=no
        ],
        [
         save_CPPFLAGS="$CPPFLAGS"
         save_LDFLAGS="$LDFLAGS"
         save_LIBS="$LIBS"

         GUCXT_CPPFLAGS=""
         GUCXT_LDFLAGS=""
         GUCXT_LIBS=""

         AS_IF([test ! -z "$with_gucxt" -a "x$with_gucxt" != "xyes" -a "x$with_gucxt" != "xguess"],
               [ucx_check_gucxt_dir="$with_gucxt"
                AS_IF([test -d "$with_gucxt/lib64"], [libsuff="64"], [libsuff=""])
                ucx_check_gucxt_libdir="$with_gucxt/lib$libsuff"
                GUCXT_CPPFLAGS="-I$with_gucxt/include $save_CPPFLAGS"
                GUCXT_LDFLAGS="-L$ucx_check_gucxt_libdir"])

         CPPFLAGS="$CPPFLAGS $GUCXT_CPPFLAGS"
         LDFLAGS="$LDFLAGS $GUCXT_LDFLAGS"

            AC_MSG_WARN([$CPPFLAGS])
            AC_MSG_WARN([$LDFLAGS])
         # Check gucxt header files
         AC_CHECK_HEADERS([gmem/api/gmem.h],
            [
                  AC_CHECK_LIB([gmem], [gmem_get_memory_type],
                  [
                  gucxt_happy="yes"
                  ],
                  [
                  gucxt_happy="no"
                  ], [-lgmem -ldl -lrt -lpthread])
                  GUCXT_LDFLAGS="$GUCXT_LDFLAGS -lgmem -lrt -ldl -lpthread"
            ],
            [
                  gucxt_happy="no",
                  GUCXT_LDFLAGS="$GUCXT_LDFLAGS -lrt -ldl -lpthread"
            ])

         CPPFLAGS="$save_CPPFLAGS"
         LDFLAGS="$save_LDFLAGS"
         LIBS="$save_LIBS"

         AS_IF([test "x$gucxt_happy" = "xyes"],
               [AC_SUBST([GUCXT_CPPFLAGS], ["$GUCXT_CPPFLAGS"])
                AC_SUBST([GUCXT_LDFLAGS], ["$GUCXT_LDFLAGS"])
                AC_SUBST([GUCXT_LIBS], ["$GUCXT_LIBS"])
                AC_DEFINE([HAVE_GUCXT], 1, [Enable GUCXT support])],
               [AS_IF([test "x$with_gucxt" != "xguess"],
                      [AC_MSG_ERROR([GUCXT support is requested but gucxt packages cannot be found])],
                      [AC_MSG_WARN([GUCXT not found])])])

        ]) # "x$with_gucxt" = "xno"

        gucxt_checked=yes
        AM_CONDITIONAL([HAVE_GUCXT], [test "x$gucxt_happy" != xno])

   ]) # "x$gucxt_checked" != "xyes"

]) # UCX_CHECK_GUCXT
