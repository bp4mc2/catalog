# Local installation

## Prerequisites:
- Installation of java JRE: https://www.java.com
- Installation of curl: https://curl.haxx.se/download.html (often already installed for Linux and Mac users)
- Windows users might need to install 7zip: https://www.7-zip.org, if not already available

To find out if you have already installed java and/or curl, please type the following statements from the command line:

```
java -version
curl --version
```

You should receive some version information, if not: please install and make sure that they are available from the command line.

## Instructions to get starten:

1. Download the zip for this repository: https://github.com/bp4mc2/catalog/archive/master.zip
2. Unzip to a directory somewhere on your local filesystem (recommended is somewhere within your home directory)
3. From: `cd local/dotwebstack`...
4. Start `install.sh` (Linux and Mac) or `install.bat` (Windows)
5. Start `start.sh` or `start.bat` to get the dotwebstack theatre running
6. Go to http://localhost:8080 to see the results

## Further instructions:

- Your dotwebstack configuration files are stores in the directory `/config/model`.
- After you change the configuration, you need to restart the dotwebstack (CTRL-C in the dotwebstack command window, and redo step 5).
