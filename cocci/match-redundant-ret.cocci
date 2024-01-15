/*
 * Match redundant temporary variable that gets returned immediatelly.
 */
@@
expression E;
type TYPE;
identifier RET;
@@

-    TYPE RET;
-    RET = E;
-    return RET;
+    return E;
