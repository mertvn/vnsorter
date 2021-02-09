# vnsorter

## What it is

This is a tool to help you organize your VN folder(s). It was mainly created to organize your downloads folder where the VNs are named following the same pattern like: "[6-digit date] [producer_name] title", but it can also be used for installed VNs, with reduced performance. 


The way it works is that it tries to extract the date and producer fields from the filename, and perform a search using only those two first. If there is a VN on the VNDB matching those, then it will automatically will be set as matched. If there is no match, or if the date and producer name can't be found, then it will try to match the title instead, and ask you to select the correct release among the results. You may choose to skip the VN instead, if you don't see the correct VN listed.

After all of the folders/files have been matched, or skipped, the tool will let you review your selected move operations, and here you can edit or select/deselect any of the VNs. After you confirm your selections, the tool will start moving the files to their destinations. After all of the move operations have finished, you will get a log of all of the successfull and unsuccessful moves, and have the option to revert them.

## Usage

### Easy

Get the latest binary from [releases](https://github.com/mertvn/vnsorter/releases) and run it. 

### Hard

1. Install Ruby >2.7

2. Clone the repository

3. `cd` into the project directory and `ruby lib/main.rb`
