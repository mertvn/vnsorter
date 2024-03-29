# vnsorter

![ss_config](https://user-images.githubusercontent.com/78761720/152635081-c5362f4b-86c5-4b90-8600-24a9477c2620.png)
![ss_choose](https://user-images.githubusercontent.com/78761720/152635083-86173e93-ed44-4584-8864-ebb512ae9443.png)


Tool to help you organize your VN folder(s). It was mainly created to organize your downloads folder where the VNs are named following the same pattern like: "[6-digit date] [producer name] title", but it can also be used for installed VNs, with reduced efficiency.

The way it works is that it tries to extract the date and producer fields from the filename, and performs a search using only those two first. If there is a VN on the VNDB matching those, then it will automatically be set as matched. If there is no match, or if the date and producer name can't be found, then it will try to match the title instead, and ask you to select the correct release among the results. You may choose to skip the VN instead, if you don't see the correct VN listed.

After all of the folders/files have been matched, or skipped, the tool will show your matches, and here you can select/deselect any of the VNs (GUI mode only). After you confirm, the tool will start moving the files to their destinations. After that's done you will get a log of all of the successful and unsuccessful moves, ~~and will have the option to revert them~~.

You should probably try it with a few VNs before using it for your entire downloads folder. Recommended usage is to run it twice, first with autoskip, then without.

## Usage

1. Install Ruby >2.7

   [Windows](https://rubyinstaller.org/downloads/) 
   
   [GNU/Linux](https://www.ruby-lang.org/en/documentation/installation/)
   

2. (Optional) Install GTK3 by typing `gem install gtk3` in the command line if you want to use the GUI

3. Clone/download this repository

4. Run it with the .bat (Windows) or the .sh (GNU/Linux) files

## Configuration

### Easy

Use the GUI.

### Hard

Open config.json in a text editor and change these values to your liking:

"source": folder

    The absolute path of the folder you want to sort, must be inside double quotes
    use forward slashes
    example: "K:/tosort"

"destination": folder

    The absolute path of the folder to put the sorted VNs in, must be inside double quotes
    use forward slashes
    example: "K:/sorted"

"languages": 2-letter language code

    The language(s) you want to search for, must be inside double quotes
    searches for all languages if empty
    if you want to search for multiple languages they should be seperated by commas
    e.g. ["ja","en","zh"]
    see the list of language codes here: https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes

"choice_producer": 0 or 1

    0: Romaji
    1: Original

"choice_date": 0 or 1 or 2

    0: [YYMMDD]
    1: [YYYY-MM-DD]
    2: [YYYY]

"choice_title": 0 or 1 or 2 or 3

    Using VN titles enables "VN mode" which makes automatic matching a lot better.
    0: Romaji release title
    1: Original release title
    2: Romaji VN title
    3: Original VN title

"choice_naming": 0 or 1 or 2 or 3 or 4 or 5 or 6

    Examples using "choice_producer": 0, "choice_date": 0, "choice_title": 1 and https://vndb.org/r196
    0: producer/[date] title
    /KID/[030516] Ever17 -The Out of Infinity-

    1: producer/[date]/title
    /KID/[030516]/Ever17 -The Out of Infinity-

    2: producer/title
    /KID/Ever17 -The Out of Infinity-

    3: title
    /Ever17 -The Out of Infinity-

    4: [date] title
    /[030516] Ever17 -The Out of Infinity-

    5: [date]/title
    /[030516]/Ever17 -The Out of Infinity-

    6: [language]/title
    /[ja]/Ever17 -The Out of Infinity-

"special_characters": 0 or 1 or 2 or 3

    Special characters are: :/<>|*"!?\
    0: Replace with Japanese variants (：／＜＞｜＊”！？￥)
    1: Replace with space
    2: Remove
    3: Keep (not recommended, will cause move operations to fail)

"discard_publishers": true or false

    You'll want to set this as false if you are sorting translations

"autoskip": true or false

    Skip instead of asking user when a perfect match cannot be found automatically

"full_title_only": true or false

    Only search the full title of the VN when doing title queries

"vnsorter_file": true or false

    Create a !vnsorter.json file inside the directory of a VN match
    you can use these files on later runs to match folders to VNs without having to
    query VNDB again
    this setting controls both the creation and the processing of !vnsorter.json files

"recursive_extraction": true or false

    Try to find VNs in the subfolders of your source folder. Not recommended, may result in weird bugs

"move": true or false

    Move files and folders instead of copying

"get_image": true or false

    GUI mode only.
    Download VN images when prompted to choose the right release.
    Images may be NSFW.
    Increases the request count, causing you to get throttled more often.

"smart_querying": true or false

    If there any Japanese characters in the filename, search only by original title,
    if not then search only by Latin title.
    Reduces the time title queries take, causing you to get throttled less often.
    Set this to false if you are sorting non-Japanese games.

"blacklist": true or false

    Ignore the words in blacklist.txt when extracting fields

"ignore_parentheses": true or false

    Ignore everything inside parentheses when extracting fields

"min_folder_length": integer

    Minimum number of characters a folder or file name must contain for it to be extracted.

"min_field_length": integer

    Minimum number of characters a field must contain for it to be extracted.

## License

Licensed under GPLv3. Gets data from the VNDB API under [Open Database License v1.0](https://opendatacommons.org/licenses/odbl/1-0/)
