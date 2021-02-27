# vnsorter

## What it is

This is a tool to help you organize your VN folder(s). It was mainly created to organize your downloads folder where the VNs are named following the same pattern like: "[6-digit date] [producer name] title", but it can also be used for installed VNs, with reduced efficiency. 

The way it works is that it tries to extract the date and producer fields from the filename, and performs a search using only those two first. If there is a VN on the VNDB matching those, then it will automatically be set as matched. If there is no match, or if the date and producer name can't be found, then it will try to match the title instead, and ask you to select the correct release among the results. You may choose to skip the VN instead, if you don't see the correct VN listed.

After all of the folders/files have been matched, or skipped, the tool will show your matches, and here you can select/deselect any of the VNs (GUI mode only). After you confirm, the tool will start moving the files to their destinations. After that's done you will get a log of all of the successful and unsuccessful moves, ~~and will have the option to revert them~~.

You should probably try it with a few VNs before using it for your entire downloads folder. Recommended usage is to run it twice, first with autoskip, then without.
## Usage

1. Install Ruby >2.7 [Windows](https://rubyinstaller.org/downloads/) [GNU/Linux](https://www.ruby-lang.org/en/documentation/installation/)

2. (Optional) Install GTK3 with `gem install gtk3` if you want to use the GUI

3. Clone/download this repository

4. Run it with the .bat (Windows) or the .sh (GNU/Linux) files

## Configuration

### Easy
  Use the GUI.
### Hard
Open config.json in a text editor and change these values to your liking:

  "source": folder  
  
    the absolute path of the folder you want to sort, must be inside double quotes
    use forward slashes 
    example: "K:/tosort"

  "destination": folder  
  
    the absolute path of the folder to put the sorted VNs in, must be inside double quotes
    use forward slashes 
    example: "K:/sorted"  

  "languages": 2-letter language code
  
    the language(s) you want to search for, must be inside double quotes
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

    0: Romaji release title
    1: Original release title
    2: Romaji VN title
    3: Original VN title  

  "choice_naming": 0 or 1 or 2 or 3 or 4 or 5 or 6  
  
    examples using "choice_producer": 0, "choice_date": 0, "choice_title": 1 and https://vndb.org/r196  
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
  
    you'll want to set this as false if you are sorting translations  

  "autoskip": true or false  

    skip instead of asking user when a perfect match cannot be found automatically  
  "full_title_only": true or false  

    only search the full title of the VN  
  "extra_file": string  

    name of the (empty) extra file to be created at the destinations
    useful for keeping track of games you haven't played yet
    e.g. !unplayed
    leave empty to not create any extra files
    
### You probably want to leave these on their default settings
 "smart_querying": true or false  
  
    If there any Japanese characters in the filename, search only by original title,
    if not then search only by Latin title.
    Set this to false if you are searching non-Japanese games.

  "blacklist": true or false  
  
    ignore the words in blacklist.txt when extracting fields

  "ignore_parentheses": true or false  
  
    ignore everything inside parentheses when extracting fields  

  "min_folder_length": integer

  "min_field_length": integer

## License

Licensed under GPLv3. Gets data from the VNDB API under [Open Database License v1.0](https://opendatacommons.org/licenses/odbl/1-0/)
