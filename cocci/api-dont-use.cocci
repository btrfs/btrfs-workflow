/*
 * Don't use obsolete API or look for alternatives that wrap the functionality:
 * - kmap/kunmap API, convert it to kmap_local_page
 * - flush_dcache_page
 * - bio_set_op_attrs
 * - s_blocksize, exception is mount
 * - i_blocksize
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
|
* i_blocksize
|
* i_blkbits
|
* s_blocksize
|
* s_blocksize_bits
)
