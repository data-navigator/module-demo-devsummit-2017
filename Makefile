short = arcgis-pro
deck = arcgis-pro
event = geopython-2017
theme = esri-uc-2017
upload_loc = 4326.us:esri/$(short)
public_loc = https://4326.us/esri/$(short)
slide_dir = $(shell pwd)

all:
	pandoc -t revealjs -s slides.md -V controls=false -V progress=true -V history=true -V center=true -V transition=slide -V theme=$(theme) --css style.css --template=src/template.revealjs --highlight-style=zenburn --slide-level 2 -S -o docs/index.html

check:
	linkchecker --check-extern index.html

pdf:
	pandoc -o ../docs/$(event)-$(deck)-presentation-handout.pdf -V fontsize=12pt -V mainfont=Calibri --latex-engine=xelatex slides.md

fullpdf:
# decktape can't scrape HTTPS URIs with a relative path, swich directories.
# Also scrape very slowly -- want backgrounds rendered.
	cd ~/dev-summit/decktape && bin/phantomjs decktape.js --pause=3000 --url=$(public_loc) --filename=$(slide_dir)/$(event)-$(deck)-demo-full.pdf

clean:
	rm ../docs/index.html ../docs/$(event)-$(deck)-presentation-handout.pdf
	../docs/$(event)-$(deck)-presentation-full.pdf

upload:
	rsync --partial --progress -r . 4326.us:esri/$(short) && open $(public_loc)
