require 'rex/proto/http'
require 'msf/core'
class Metasploit3 < Msf::Auxiliary
	include Msf::Exploit::Remote::HttpClient
	include Msf::Auxiliary::Scanner
	def initialize
		super(
			'Name'        => 'Wordpress Version Detector 2.0',
			'Description' => 'Detects Running Version Of Wordpress',
			'Author'      => 'Nipun_Jaswal',
			'License'     => MSF_LICENSE)
			register_options(
			[
				OptString.new('DIRS', [ true,  "Wordpress Directory", '/wordpress/']),
			], self.class)
	end
	def run_host(ip)
		begin
			connect
			user=(datastore['DIRS'])
			query="#{user}"+"readme.html"	
			req= send_request_raw({'uri' =>query, ',method' => 'GET' })
			g1= (req.body =~ /Version/)
			n1=g1.to_i+8
                        ver1= req.body[n1,3]
                        print_line("Site is Running Wordpress #{ver1}")
		end
	end

end

