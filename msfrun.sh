#Copy Meterpreter Scripts to Metasploit
cp book_meterpreter_scripts/* /usr/share/metasploit-framework/scripts/meterpreter/
# Load Modules Folder and Launch Metasploit
msfconsole -m modules/
