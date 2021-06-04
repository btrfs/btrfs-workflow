/*
 * Where multiplication could be replaced by shift, needs manual review.
 */
@@
expression E1, E2;
@@
(
- E1 * E2->sectorsize
+ (E1 << E2->sectorsize_bits)
|
- E1 / E2->sectorsize
+ (E1 >> E2->sectorsize_bits)
)
