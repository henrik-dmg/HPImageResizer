.PHONY: all

all:
	swift build -c release
	cp -f .build/release/hpresizer /usr/local/bin/hpresizer
	rm -r .build/release
	echo "Installed hpresizer into /usr/local/bin/"
