# TODO

## Fixes:

- Optimize insert_producers
- Click on the release ID to open the vndb page
- Find a way to not have to re-encode everything for Windows
- ~~Replace forbidden characters like ":, /" in filenames https://stackoverflow.com/a/31976060 - replace with jpn variants if possible~~done (check vns that have those characters in producers and titles)
- Fix Y2k80 problem
- Extractor needs to ignore space inside brackets when splitting to fields
- Support aliases
- Deal with multiple dates in filename
- try using the "search" filter on "get vn" to get vns instead
- Deal with releases that have a publisher but no developer

- Send all API requests at once (allsearch done, titlesearch left)
- Handle throttling properly


### Organization

- Find better names for things in general (esp. "map", "selected", "title" and "subtitle", "search" and "query")
- Consider making Search, AllSearch, TitleSearch classes

## New features:

- Extractor should have the option to work with files instead of folders
- Ability to revert move(s) using move history

- Match VN and release titles to give the option to strip release specific stuff like "ダウンロード版"
- Differentiate between VN title and release title ^ vv
- Allow users to choose between romaji or original title v
- Allow users to select what kind of folder structure/naming they want
- Support multiple producers for one release ^
- Give different date options like YYMMDD YYYY-MM-DD etc. ^^
- make the parenteses and blacklist ignoring optional ^^^
- Support more than 25 options per title
- Offline ver. using data dumps
- Proper exception handling; skip if anything goes wrong
- if releases.length > 1 try to match the title
