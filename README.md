# ZEsarUX Installer & Updater
ZEsarUX Installation script written in BASH

ZEsarUX is the best ZX Spectrum, Amstrad and SAM Emulator for Linux. The source files are available from [https://github.com/chernandezba/zesarux/](https://github.com/chernandezba/zesarux/).

Documentation for the machines emulated by ZEsarUX can be found [here](https://github.com/chernandezba/zesarux-extras/tree/master/extras)

ZEsarUX documentation is [here](https://github.com/chernandezba/zesarux/tree/master/src/docs)

This ZEsarUX Install & Update script downloads/clones the source files to HOME/src/zesarux then builds and installs the ZEsarUX emulator complete with desktop application icon.

This script is written by me (Lee Hodson). ZEsarUX is developed by Cesar Hernandez Bano. The only relationship this script has with Cesar is that this script installs Cesar's program.

## TO RUN

Download the file zesarux.sh from this repository.

Ensure the script is executable:

`Right-click > properties > Executable`

OR

`chmod u+x zesarux.sh`

Launch the script by clicking the script `zesarux.sh` file or through the command line by entering the directory where the script resides and typing `bash ./zesarux.sh` at the prompt. It is important to type 'bash' in that instruction or the script won't run.

When the script runs, if menu item 4 displays in the installer's options, choose it before you install ZEsarUX. This option will install the software necessary for ZEsarUX to install and run properly.

After installation, run ZEsarUX by typing `zesarux` at the command line or by typing `zesarux` into your application launcher (Alt+F2 or Kicker etc...), or run ZesarUX by hittng the application icon under Games.

## HELP

View the help text by running ZEsarUX from the command line with

`zesarux --experthelp` to see all available launch options.

OR

`zesarux --help` to see basic machine launch options.

Alternatively read the documents linked above.

## DONATIONS

Donate to the developer of this installer script https://paypal.me/vr51

Donate to the developer of ZEsarUX [ZEsarUX](https://github.com/chernandezba/zesarux/)

## TECHNICAL INFO YOU DONT NEED TO KNOW

ZEsarUX will be compiled in `$HOME/src/zesarux/src`.

Files that exist in `$HOME/src/zesarux` will be overwritten or updated when this installer script is run, depending on the build mode set within the installer's options.

The ZEsarUX installer is installed to `/usr/local/bin/zesarux`. That's where it should install to, anyway. If it is not found there you can locate it from the command line with `whereis -b zesarux`.

If you need to reinstall the Essential Software just edit the installer script to set `conf[0]=1` to `conf[0]=0` and re-run zesarux.sh.

You can see where the ZEsarUX program is installed to by typing `whereis -b zesarux` into a terminal. This may be helpful if you cannot run the program.

## LIMITATIONS

You will need spectrum game files (ROMs) to use this emulator enjoyably.
Visit https://journalxtra.com/gaming/download-complete-sets-of-mess-and-mame-roms/ to find some spectrum games.
