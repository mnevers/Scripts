# Scripts
Perl, PHP, Python, Java, C#, Shell example scripts. Each script is documented as a header within the code. Here is a summary for each scripted included within this repository 'Scripts'

# CleanList.sh
Sorts all positional parameters given to this program into a clean list leaving them in 
the order give whilst removing duplicate strings in the list. :: while be interpreted as :.: or :.

# DiskUsage.sh
DiskUsage.sh checks all the local drives exluding /proc for a storage capacity of over 90% or 60% and sends warning logs via email accordingly. Make sure your system has Mailutils correctly installed and configured in /etc/postfx
The first positional paramater is the recipient email of this disk usage logger. For example: someone@example.com
This program works best when setup with Crontab so as to excecute automatically and on a fixed schedule per the end users needs

# matthewnevers_rps.py
matthewnevers_rps.py reads in an arbitrary number.  The first argument (rounds)
is used as the number of rounds if the user wants to run the program more expediently
To execute the program simply enter python matthewnevers_rps.py (# of rounds)
if no argument is given the program will ask at run time for a number

# matthewnevers_sort.pl
matthewnevers_sort.pl reads in an arbitrary number of strings from the command line and displays them sorted alphabetically
To execute the program simple enter perl matthewnevers_sort.pl x x x (x's being strings to sort) you may also add -r to reverse the sort order or -h for help.

# XMLManager.cs
This script was created for one of my role-playing game projects.
XMLManager.cs serializes large amounts of data to xml spreadsheets for easy viewing and processing during and after Run-time.
The rest of serialization occurs through Unity's PlayerPrefs in the registry with headers of 1, 2 or 3 according to current save.

# CurrencyManager.cs
This scrip was created for one of my role-playing game projects.
CurrencyManager.cs will be used to add and remove currency between bank and player inventory.
