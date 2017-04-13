#!/bin/sh
esc()
{
	printf %s "$1" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g;'
}


cat <<EOFhtml >index.html
<!DOCTYPE html>
<html>
<body>
$(while IFS='	' read -r name network dataurl versions lines; do
	cat <<EOFentry
	<div>
		<h2>
			$(esc "$name ($network)")
		</h2>
$(while test $((versions--)) -gt 0; do
	IFS='	' read -r vname url examples
	cat <<EOFversion
		<div>
			<h3>
				<a href="$url">$(esc "$vname")</a>
			</h3>
$(test "$dataurl" && cat <<EOFdata
			<br><a href="$dataurl">Training data</a>
EOFdata
)
$(printf '%s\n' "$examples" | tr '	' '\n' | while read -r example; do
	cat <<EOFexample
			<div>
				<audio controls src="$example"></audio>
			</div>
EOFexample
done)
		</div>
EOFversion
done)
		<div>
$(while test $((lines--)) -gt 0; do
	cat <<EOFline
			<br>$(esc "$(head -n 1)")
EOFline
done)
		</div>
	</div>
EOFentry
done <entries)
</body>
</html>
EOFhtml
