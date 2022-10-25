/*
 * Don't use obsolete API or look for alternatives that wrap the functionality:
 * - kmap/kunmap API, convert it to kmap_local_page
 * - flush_dcache_page
 * - bio_set_op_attrs
 */
@@
@@

(
* kmap(...)
|
* kunamp(...)
|
* flush_dcache_page(...)
|
* bio_set_op_attrs(...)
)
