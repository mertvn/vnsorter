# vnsorter

## What it is

This is a tool to help you organize your VN folder(s). It was mainly created to organize your downloads folder where the VNs are named following the same pattern like: "[6-digit date] [producer name] title", but it can also be used for installed VNs, with reduced efficiency. 

The way it works is that it tries to extract the date and producer fields from the filename, and performs a search using only those two first. If there is a VN on the VNDB matching those, then it will automatically be set as matched. If there is no match, or if the date and producer name can't be found, then it will try to match the title instead, and ask you to select the correct release among the results. You may choose to skip the VN instead, if you don't see the correct VN listed.

After all of the folders/files have been matched, or skipped, the tool will show your selected move operations~~, and here you can select/deselect any of the VNs~~. After you confirm, the tool will start moving the files to their destinations. After that's done you will get a log of all of the successful and unsuccessful moves, and will have the option to revert them.

## Usage

### Easy

Get the latest release from [releases](https://github.com/mertvn/vnsorter/releases) and run start.bat(Windows) or start.sh(GNU/Linux). (No installation necessary) (if you try to run the binary directly the text won't display properly)

### Hard

1. Install Ruby >2.7

2. Clone the repository

3. `cd` into the project directory and `ruby lib/main.rb`

## Configuration

### Open config.json in a text editor and change these values to your liking:

  "source": folder  
  
    the absolute path of the folder you want to sort, must be inside double quotes

  "destination": folder  
  
    the absolute path of the folder to put the sorted VNs in, must be inside double quotes

  "choice_producer": 0 or 1  
  
    0: Romaji 
    1: Original

  "choice_date": 0 or 1 or 2  

  
    0: [YYMMDD]
    1: [YYYY-MM-DD]
    2: [YYYY]
  "choice_title": 0 or 1  
  
    0: Romaji 
    1: Original

  "choice_naming": 0 or 1 or 2 or 3 or 4 or 5 or 6  
  
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

  examples using "choice_producer": 0, "choice_date": 0, "choice_title": 1 and https://vndb.org/r196



### You probably want to leave these alone
  "special_characters": 0 or 1 or 2 or 3  
  
    0: Replace with Japanese variants (：／＜＞｜＊”！？￥)
    1: Replace with space
    2: Remove
    3: Keep (not recommended, will cause move operations to fail)
  Special characters are: :/<>|*"!?\

  "blacklist": true or false  

  "ignore_parentheses": true or false  

  "discard_publishers": true or false

  "min_folder_length": 3

  "min_field_length": 3

this was going to have a [GUI](https://github.com/mertvn/vnsorter/blob/master/img/gui.png?raw=true) but GTK just refused to be packed
