/*
 * Use optimized version for full page copy
 */
@@
expression A, B;
@@

- memcpy(A, B, PAGE_SIZE)
+ copy_page(A, B)
