/**
 * Copyright (C) Advanced Micro Devices, Inc. 2019.  ALL RIGHTS RESERVED.
 * Copyright (c) NVIDIA CORPORATION & AFFILIATES, 2020. ALL RIGHTS RESERVED.
 *
 * See file LICENSE for terms.
 */

#ifdef HAVE_CONFIG_H
#  include "config.h"
#endif

#include <tools/perf/lib/libperf_int.h>

#include <ucs/sys/compiler.h>
#include <gmem/api/gmem.h>

static ucs_status_t ucx_perf_gucxt_init(ucx_perf_context_t *perf)
{
    gmem_status_t ret;
    unsigned group_index;

    group_index = rte_call(perf, group_index);
    
    ret = gmem_init(group_index);
    if(ret != GMEM_SUCCESS) {
        ucs_error("failed to initialize gucxt %d", group_index);
        return UCS_ERR_NO_DEVICE;
    }

    return UCS_OK;
}

static inline ucs_status_t ucx_perf_gucxt_alloc(size_t length,
                                               ucs_memory_type_t mem_type,
                                               uct_allocated_memory_t *alloc_mem)
{
    gmem_status_t ret;

    ucs_assert((mem_type == UCS_MEMORY_TYPE_GUCXT) ||
               (mem_type == UCS_MEMORY_TYPE_GUCXT_MANAGED));

    ret = gmem_alloc(&alloc_mem->gmem, length);
    if (ret != GMEM_SUCCESS) {
        ucs_error("failed to allocate memory");
        return UCS_ERR_NO_MEMORY;
    }
    alloc_mem->address = alloc_mem->gmem.ptr;
    return UCS_OK;
}

static inline ucs_status_t
uct_perf_gucxt_alloc_reg_mem(const ucx_perf_context_t *perf,
                            size_t length,
                            ucs_memory_type_t mem_type,
                            unsigned flags,
                            uct_allocated_memory_t *alloc_mem)
{
    ucs_status_t status;

    status = ucx_perf_gucxt_alloc(length, mem_type, alloc_mem);
    if (status != UCS_OK) {
        return status;
    }

    status = uct_md_mem_reg(perf->uct.md, alloc_mem->address,
                            length, flags, &alloc_mem->memh);
    if (status != UCS_OK) {
        gmem_free(&alloc_mem->gmem);
        ucs_error("failed to register memory");
        return status;
    }

    alloc_mem->mem_type = mem_type;
    alloc_mem->md       = perf->uct.md;

    return UCS_OK;
}

static ucs_status_t uct_perf_gucxt_alloc(const ucx_perf_context_t *perf,
                                        size_t length, unsigned flags,
                                        uct_allocated_memory_t *alloc_mem)
{
    return uct_perf_gucxt_alloc_reg_mem(perf, length, UCS_MEMORY_TYPE_GUCXT,
                                       flags, alloc_mem);
}

static ucs_status_t uct_perf_gucxt_managed_alloc(const ucx_perf_context_t *perf,
                                                size_t length, unsigned flags,
                                                uct_allocated_memory_t *alloc_mem)
{
    return uct_perf_gucxt_alloc_reg_mem(perf, length, UCS_MEMORY_TYPE_GUCXT_MANAGED,
                                       flags, alloc_mem);
}

static void uct_perf_gucxt_free(const ucx_perf_context_t *perf,
                               uct_allocated_memory_t *alloc_mem)
{
    ucs_status_t status;

    ucs_assert(alloc_mem->md == perf->uct.md);

    status = uct_md_mem_dereg(perf->uct.md, alloc_mem->memh);
    if (status != UCS_OK) {
        ucs_error("failed to deregister memory");
    }

    gmem_free(&alloc_mem->gmem);
}

static void ucx_perf_gucxt_memcpy(void *dst, ucs_memory_type_t dst_mem_type,
                                 const void *src, ucs_memory_type_t src_mem_type,
                                 size_t count)
{
    gmem_status_t ret;

    ret = gmem_memcpy(dst, src, count);
    if (ret != GMEM_SUCCESS) {
        ucs_error("failed to copy memory: %s, mem type: %s", gmem_error_str(ret), gmem_mem_type_str());
    }
}

static void* ucx_perf_gucxt_memset(void *dst, int value, size_t count)
{
    gmem_status_t ret;

    ret = gmem_memset(dst, value, count);
    if (ret != GMEM_SUCCESS) {
        ucs_error("failed to set memory: %s, mem type: %s", gmem_error_str(ret), gmem_mem_type_str());
    }

    return dst;
}

UCS_STATIC_INIT {
    static ucx_perf_allocator_t gucxt_allocator = {
        .mem_type  = UCS_MEMORY_TYPE_GUCXT,
        .init      = ucx_perf_gucxt_init,
        .uct_alloc = uct_perf_gucxt_alloc,
        .uct_free  = uct_perf_gucxt_free,
        .memcpy    = ucx_perf_gucxt_memcpy,
        .memset    = ucx_perf_gucxt_memset
    };
    static ucx_perf_allocator_t gucxt_managed_allocator = {
        .mem_type  = UCS_MEMORY_TYPE_GUCXT_MANAGED,
        .init      = ucx_perf_gucxt_init,
        .uct_alloc = uct_perf_gucxt_managed_alloc,
        .uct_free  = uct_perf_gucxt_free,
        .memcpy    = ucx_perf_gucxt_memcpy,
        .memset    = ucx_perf_gucxt_memset
    };

    ucx_perf_mem_type_allocators[UCS_MEMORY_TYPE_GUCXT]         = &gucxt_allocator;
    ucx_perf_mem_type_allocators[UCS_MEMORY_TYPE_GUCXT_MANAGED] = &gucxt_managed_allocator;
}
UCS_STATIC_CLEANUP {
    ucx_perf_mem_type_allocators[UCS_MEMORY_TYPE_GUCXT]         = NULL;
    ucx_perf_mem_type_allocators[UCS_MEMORY_TYPE_GUCXT_MANAGED] = NULL;
}
