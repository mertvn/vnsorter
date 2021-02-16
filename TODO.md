# TODO

## Fixes:

### Search

- make releases.length > 1 title matching fuzzy somehow
- Send all API requests at once (allsearch done, titlesearch left)
- Handle throttling properly

### Extractor

- Deal with multiple dates in filenames

### Organization

- Find better names for things in general (esp. "map", "selected", "title" and "subtitle", "search" and "query")
- split main() into multiple methods

### waiting on GUI

- Click on the release ID to open the vndb page
- Ability to revert move(s) using move history
- option to add a file? to vn folders to mark unplayed VNs etc.
- make gui remember previous choices (load existing config)
- don't proceed unless sort button was pressed

### console

- ask_user_producer

## maybe:

- Extractor should support files as well
- Support more than 25 options per title
- Offline ver. using data dumps
- Proper exception handling; skip if anything goes wrong
- Fix Y2k80 problem
- support non-YYMMDD dates in filenames
- save/load from file
- caching