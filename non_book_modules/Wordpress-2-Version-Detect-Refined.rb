require 'rex/proto/http'
require 'msf/core'
class Metasploit3 < Msf::Auxiliary
	include Msf::Exploit::Remote::HttpClient
	include Msf::Auxiliary::Scanner
	include Msf::HTTP::Wordpress
	def initialize
		super(
			'Name'        => 'Wordpress Version Detector 2.0',
			'Description' => 'Detects Running Version Of Wordpress',
			'Author'      => 'Nipun_Jaswal',
			'License'     => MSF_LICENSE)
			register_options(
			[
			], self.class)
	end
	def run_host(ip)
		begin
			ver = wordpress_version
			print_line("#{ver}")
		end
	end

end

