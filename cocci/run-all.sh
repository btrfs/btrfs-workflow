#!/bin/sh
# Usage: $0 [directory]
#
# Looks for the scripts in the symlink base directory, so run this from your
# sources a specify full path to the script. The results are in a .diff file of
# the same name as the semantic script and are overwritten on each run.

here=`pwd`
base=`readlink -f $(dirname "$0")`

for cocci in "$base"/*.cocci; do
	echo "=== Running $cocci"
	out="$cocci".diff
	spatch -sp_file "$cocci" -dir . -include_headers -quiet -very-quiet -j 4 2>&1 > "$out"
	if [ -s "$out" ]; then
		echo "Something found ($out)"
	else
		echo "Nothing found"
		rm -- "$out"
	fi
done
