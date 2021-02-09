# TODO

## Fixes:

### Search

- Support aliases (allsearch done, titlesearch left)
- try using the "search" filter on "get vn" to get vns instead
- Deal with releases that have a publisher but no developer
- Support multiple producers for one release 

- Send all API requests at once (allsearch done, titlesearch left)
- Handle throttling properly

### Extractor

- Ignore space inside brackets when splitting to fields
- Deal with multiple dates in filename
- Deal with no spaces e.g. [producer][title]
- Deal with periods e.g. [producer].subtitle1.subtitle2.subtitle3
- Deal with producer names like this [HULOTTE（ユロット）]

### Organization

- Find better names for things in general (esp. "map", "selected", "title" and "subtitle", "search" and "query")
- Consider making Search, AllSearch, TitleSearch classes

### waiting on GUI

- Click on the release ID to open the vndb page
- Ability to revert move(s) using move history
- Match VN and release titles to give the option to strip release specific stuff like "ダウンロード版"
- Differentiate between VN title and release title 
- Allow users to choose between romaji or original title 
- Allow users to select what kind of folder structure/naming they want
- make the parenteses and blacklist ignoring optional 
- Give different date options like YYMMDD YYYY-MM-DD etc. 

## maybe:

- Extractor should have the option to work with files instead of folders
- Support more than 25 options per title
- Offline ver. using data dumps
- Proper exception handling; skip if anything goes wrong
- if releases.length > 1 try to match the title
- Fix Y2k80 problem
