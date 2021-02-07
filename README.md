# TODO

## Fixes:

- Find better names for things in general (esp. "map", "selected", "title")
- Optimize company insertion in title_query
- Click on the release ID to open the vndb page
- Match VN and release titles to give the option to strip release specific stuff like "ダウンロード版"
- Change all instances of "company" to "producer"
- Find a way to not have to re-encode everything for Windows
- Blocklist the "(iso+rar+txt)" stuff
- Replace forbidden characters like ":" in filenames https://stackoverflow.com/a/31976060 - replace with jpn variants if possible
- Use producer "type" to only get developers somehow

- Handle throttling properly
- Send all API requests at once
- Support more than 25 options per title

### Organization

- Move different search categories to different files
- Move main.rb contents into search
- Rethink @selected

## New features:

- Extractor should have the option to work with files instead of folders
- Move history to revert move(s)

- Allow users to choose between romaji or original title vvv
- Allow users to select what kind of folder structure/naming they want
- Support multiple companies for one release ^^^
- Give different date options like YYMMDD YYYY-MM-DD etc.
