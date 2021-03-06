#!/bin/bash
set -ue

# check that tools are present
echo '[*] ffmpeg:'
which ffmpeg
echo '[*] sox:'
which sox
echo '[*] id3cp:'
which id3cp

# to make filename extension check below case-insensitive
shopt -s nocasematch

# skip hidden files
for i in input/*; do
	if [ ! -f "$i" ]; then
		continue;
	fi
	INPUT="$i"
	OUTPUT="output/`basename \"$i\"`"
	OUTPUT=`echo "$OUTPUT" | perl -npe 's/\.[^.]*$/.mp3/'`
	# decode original file and mixdown to mono
	# cut silence - shoutout to http://digitalcardboard.com/blog/2009/08/25/the-sox-of-silence/
	# compress dynamic range - http://forum.doom9.org/showthread.php?t=165807
	# speed up 25%
	# encode MP3
	echo "[*] $INPUT"
	echo " -> $OUTPUT"
	ffmpeg -loglevel quiet -i "$INPUT" -vn -acodec pcm_s16le -f wav -ac 1 - \
		| sox -t wav - -t wav - compand 0.3,1 6:-70,-60,-20 -5 -90 silence -l 1 0.1 1% -1 2.0 1% \
		| ffmpeg -loglevel quiet -i - -ac 2 -filter:a "atempo=1.25" -ar 22050 -ab 64k -f mp3 -joint_stereo 1 "$OUTPUT"

	if [[ "$INPUT" =~ \.mp3$ ]]; then
		id3cp "$INPUT" "$OUTPUT"
	fi

	rm "$INPUT"
done

