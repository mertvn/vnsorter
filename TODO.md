# TODO

## Fixes:

### Search

- Match VN and release titles to give the option to strip release specific stuff like "ダウンロード版"

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
- option to add a file? to vn folders to mark unplayed games etc.

## maybe:

- Extractor should have the option to work with files instead of folders
- Support more than 25 options per title
- Offline ver. using data dumps
- Proper exception handling; skip if anything goes wrong
- if releases.length > 1 try to match the title
- Fix Y2k80 problem
- support non-YYMMDD dates in filenames
- save/load from file
