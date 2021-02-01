# arma-3-server-mods-updator
A Batch Script to update arma 3 server mods.

## Description

This script will read the mods id from a list and ask to login in the steam account that has Arma 3.
And then it will download the mods if they are not present in the steam's arma 3 workshop content folder, if they are it will update them.
After that, a link will be created with a folder named @modname in the Arma 3 Server folder with the downloaded mod folder and
another link will also be created with the downloaded mod's key in the Arma 3 Server key's folder.


Hope you enjoy and save some trouble with mods management in arma 3 server.


## Instructions
 - Create a text file with the mods list where each line must contain one Mod ID and if you want to skip a line, it must start with ``--``  
   As exemple:  
   ``modlist.txt`` <<
   ```txt
   --Some mod 1
   123456701
   --Some mod 2
   123456702
   --Some mod 3
   123456703
   --Generic weapon mod
   --1254102
   --I love this mods
   696969696
   525252525
   ```
 - You need to set path of the text file containing the mods list, the folder path containing the steam cmd, and the Arma 3 server folder.
   To set them you can edit this script and change these lines as follows:
   ```batch
   set "listdir=C:\ARMA3_SERVER\modslist.txt"
   set "steamCMDdir=C:\ARMA3_SERVER\steam_cmd"
   set "serverDir=C:\ARMA3_SERVER"
   ```
   Or you can start this script with the following parameters to automatically set these locations:  
   ```--mods "C:\ARMA3_SERVER\modslist.txt"```
   ```--steam "C:\ARMA3_SERVER\steam_cmd"```
   ```--server "C:\ARMA3_SERVER"```
   
   - OBS: When setting the steam cmd folder and the server folder path, they need to point to a folder, not the steam cmd executable or arma 3 server executable !
