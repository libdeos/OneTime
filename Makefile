# Makefile for OTP.

prefix = /usr/local
bindir = $(prefix)/bin

all: check

test: check
check:
	@./check.sh

# For a quick sanity check while developing, just run this.
quickcheck:
	@(cd tests; ./quick-check)

install:
	@install -d -m 0755 $(bindir)
	@install -m755 onetime $(bindir)

uninstall:
	@rm -v $(bindir)/onetime

distclean: clean
clean:
	@rm -rf home test-msg.* *~ onetime-*.* onetime-*.tar.gz onetime-*.zip

dist:
	@./make-dist.sh

www: dist
	@(cd css; ./get-deps)
	@cp images/logo/favicons/favicon.ico ./favicon.ico
	@./onetime --intro     > intro.tmp
	@./onetime --help      > usage.tmp
	@./onetime --pad-help  > pad-help.tmp
	@# Escape and indent all the help output.
	@sed -e 's/\&/\&amp;/g' < intro.tmp > intro.tmp.tmp
	@mv intro.tmp.tmp intro.tmp
	@sed -e 's/</\&lt;/g' < intro.tmp > intro.tmp.tmp
	@mv intro.tmp.tmp intro.tmp
	@sed -e 's/>/\&gt;/g' < intro.tmp > intro.tmp.tmp
	@mv intro.tmp.tmp intro.tmp
	@sed -e 's/^\(.*\)/   \1/g' < intro.tmp > intro.tmp.tmp
	@mv intro.tmp.tmp intro.tmp
	@sed -e 's/\&/\&amp;/g' < usage.tmp > usage.tmp.tmp
	@mv usage.tmp.tmp usage.tmp
	@sed -e 's/</\&lt;/g' < usage.tmp > usage.tmp.tmp
	@mv usage.tmp.tmp usage.tmp
	@sed -e 's/>/\&gt;/g' < usage.tmp > usage.tmp.tmp
	@mv usage.tmp.tmp usage.tmp
	@sed -e 's/^\(.*\)/   \1/g' < usage.tmp > usage.tmp.tmp
	@mv usage.tmp.tmp usage.tmp
	@sed -e 's/\&/\&amp;/g' < pad-help.tmp > pad-help.tmp.tmp
	@mv pad-help.tmp.tmp pad-help.tmp
	@sed -e 's/</\&lt;/g' < pad-help.tmp > pad-help.tmp.tmp
	@mv pad-help.tmp.tmp pad-help.tmp
	@sed -e 's/>/\&gt;/g' < pad-help.tmp > pad-help.tmp.tmp
	@mv pad-help.tmp.tmp pad-help.tmp
	@sed -e 's/^\(.*\)/   \1/g' < pad-help.tmp > pad-help.tmp.tmp
	@mv pad-help.tmp.tmp pad-help.tmp
	@cat home-top            \
             intro.tmp                 \
             home-middle-top     \
             usage.tmp                 \
             home-middle-bottom  \
             pad-help.tmp              \
             home-bottom         \
           > home
	@# Substitute in the release numbers.
	@sed -e "s|1XVERSION|`./find-ver.sh 1`|g" \
           < home > home.tmp
	@sed -e "s|2XVERSION|`./find-ver.sh 2`|g" \
           < home.tmp > home
	@sed -e "s|1XVERSION|`./find-ver.sh 1`|g" \
           < get-tmpl > get.tmp
	@sed -e "s|2XVERSION|`./find-ver.sh 2`|g" \
           < get.tmp > get
	@sed -e "s|1XVERSION|`./find-ver.sh 1`|g" \
           < changes-tmpl > changes.tmp
	@sed -e "s|2XVERSION|`./find-ver.sh 2`|g" \
           < changes.tmp > changes
	@rm get.tmp
	@rm changes.tmp
	@# Make the GPG link live.
	@sed -e 's/GnuPG,/<a href="http:\/\/www.gnupg.org\/">GnuPG<\/a>,/g' \
           < home > home.tmp
	@mv home.tmp home
	@# Make the Wikipedia link live.
	@sed -e 's| http://en.wikipedia.org/wiki/One-time_pad | <a href="http://en.wikipedia.org/wiki/One-time_pad">http://en.wikipedia.org/wiki/One-time_pad</a> |g' \
           < home > home.tmp
	@mv home.tmp home
	@# Make the author name link live.
	@sed -e 's|Karl Fogel|<a href="http://red-bean.com/kfogel">Karl Fogel</a>|g' \
           < home > home.tmp
	@mv home.tmp home
	@# Make the home page link live.
	@sed -e 's| http://www.red-bean.com/onetime/| <a href="http://www.red-bean.com/onetime/">http://www.red-bean.com/onetime/</a>|g' \
           < home > home.tmp
	@mv home.tmp home
	@# Make the license link live.
	@sed -e 's| LICENSE | <a href="LICENSE">LICENSE</a> |g' \
           < home > home.tmp
	@mv home.tmp home
	@# Make the random-vs-urandom discussion link live.
	@sed -e 's|http://www.2uo.de/myths-about-urandom/|<a href="http://www.2uo.de/myths-about-urandom/">http://www.2uo.de/myths-about-urandom/</a>|g' \
           < home > home.tmp
	@mv home.tmp home
	@rm intro.tmp usage.tmp pad-help.tmp

debian: deb
deb: dist
	(cd debian; ./make-deb.sh)
	@rm -rf onetime-1.*
