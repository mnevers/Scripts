# Scripts
These are PowerShell, Perl, PHP, Python, Java, C#, and Shell example scripts compiled from various Work, University and personal (Video Game) projects. Each script is documented through a header within the code. Here is a summary for each script included within this repository

# OnBoardUser.ps1
This Powershell script automatically creates a new user in Microsoft Active Directory with attributes, OU, and group membership based on existing user with the same or similar role. This script allows End User Support
team to save 20 minutes each time a new user is Onboarded. Reducing repetive administrative workload.

# historical_earnings_move.py
This Python script uses the yfinance API to get historical stock information. In this case it pulls based on passed parameter of stock ticker the open and closing price after historical earnings releases. Then at the end
gives the cumulative average historical move and how often it closes up or down on earnings.

# NasRestore.ps1
This Powershell script was used in the event of a NAS failure in which only partical data recovery was possible from the live disks which had to then be merged with partial data availability from AWS S3 backups.
The partial disk restore and AWS files had different Pathing to account for as well as different metadata. The files with the most recent changes were considered most viable and were picked in case of duplicates.

# MobileNumberChange.ps1
This PowerShell script reads in the mobile number attribute from all AD users in a given OU
Removes unncessary characters I.E " " "()" etc
Adds a leading + and a 1 for USA country code if necessary
Script will work on phone numbers that may have already been formatted properly as well
Ignores blank mobile fields

# CleanList.sh
Sorts all positional parameters given to this program into a clean list leaving them in 
the order given whilst removing duplicate strings in the list. :: will be interpreted as :.: or :.

# DiskUsage.sh
DiskUsage.sh checks all the local drives exluding /proc for a storage capacity of over 90% or 60% and sends warning logs via email accordingly. Make sure your system has Mailutils correctly installed and configured in /etc/postfx.
The first positional paramater is the recipient email of this disk usage logger. For example: someone@example.com
This program works best when setup with Crontab so as to excecute automatically and on a fixed schedule per the end users needs

# matthewnevers_rps.py
matthewnevers_rps.py is a rock paper scissors game played in the terminal. The script reads in an arbitrary number.  The first argument is used as the number of rounds if the user wants to run the program more expediently. To execute the program simply enter python matthewnevers_rps.py (# of rounds) if no argument is given the program will ask at run time for a number. Once the game is being played a 0 input is rock, a 1 is paper and a 2 is scissors. The player will face off against a random number generator.

# matthewnevers_sort.pl
matthewnevers_sort.pl reads in an arbitrary number of strings from the command line and displays them sorted alphabetically
To execute the program simple enter perl matthewnevers_sort.pl x x x (x's being strings to sort) you may also add -r to reverse the sort order or -h for help.

# XMLManager.cs
This script was created for one of my role-playing game projects.
XMLManager.cs serializes large amounts of data to xml spreadsheets for easy viewing and processing during and after Run-time.
The rest of serialization occurs through Unity's PlayerPrefs in the registry with headers of 1, 2 or 3 according to current save.

# CurrencyManager.cs
This script was created for one of my role-playing game projects.
CurrencyManager.cs will be used to add and remove currency between bank and player inventory.
