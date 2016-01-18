podcast-munger
===

A small bash script to encode my podcasts the way I need them.

## usage

- place the inputs in input/ (warning! these will be deleted after processing!)
- `./munge.sh`
- dring tea :-)
- get your outputs from output/

## what it does

- decode the input and mixes it down to mono
- cut silence longer that 1 second
- compresses the dynamic range
- speeds it up by 25%
- encodes it as a 64kbit CBR joint-stereo MP3

## dependencies

- [ffmpeg](https://www.ffmpeg.org/)
- [sox](http://sox.sourceforge.net/)
- perl (because getting regular expressions to work in bash is just too hard!)
