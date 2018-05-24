require 'rex/proto/http'
require 'msf/core'
class Metasploit3 < Msf::Auxiliary
	include Msf::Exploit::Remote::HttpClient
	include Msf::Auxiliary::Scanner
	include Msf::HTTP::Wordpress
	include Msf::HTTP::Wordpress::Users
	def initialize
		super(
			'Name'        => 'Wordpress Version Detector 2.0',
			'Description' => 'Detects Running Version Of Wordpress',
			'Author'      => 'Nipun_Jaswal',
			'License'     => MSF_LICENSE)
			register_options(
			[
			OptString.new('UserC', [true, 'Enter Username to Check', 'admin']),
			], self.class)
	end
	def run_host(ip)
		begin
			#Version Detection
			ver = wordpress_version
			print_line("Wordpress Version: #{ver}")
			#User Enumeration
			a = wordpress_user_exists?(datastore['UserC'])
			usr = datastore['UserC']
			if a
			print_line("Username: #{usr} Status: Exist")
			else
			print_line("Username:#{usr} Status: Does not Exist")
			end
		end
	end

end

