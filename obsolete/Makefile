#
# Makefile to generate the obsolete packages and distributions
#

all:
	l3build unpack

clean:
	l3build clean
	rm -r build

dist-ctan:
	l3build ctan

help:
	@echo "all:       generate all files"
	@echo "clean:     remove all generated files and the temporary files and folders"
	@echo "dist-ctan: generate a CTAN distribution of KOMA-Script obsolete"
