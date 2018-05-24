require 'rex/proto/http'
require 'msf/core'
class Metasploit3 < Msf::Auxiliary
	include Msf::Exploit::Remote::HttpClient
	include Msf::Auxiliary::Scanner
	def initialize
		super(
			'Name'        => 'Wordpress Version Detector',
			'Description' => 'Detects Running Version Of Wordpress',
			'Author'      => 'Nipun_Jaswal',
			'License'     => MSF_LICENSE)
			register_options(
			[
				OptString.new('USER', [ true,  "Check /wp-includes/admin-bar.php", 'username']),
			], self.class)
	end
	def run_host(ip)
		begin
			connect
			#Query To Find Username
			user=(datastore['USER'])
			query="/~"+"#{user}/readme.html"	
			req= send_request_raw({'uri' =>query, ',method' => 'GET' })
			if req.code >400
			query2="/~"+"#{user}"+"/"
			req2= send_request_raw({'uri' =>query2, ',method' => 'GET' })
			g1= (req2.body =~ /[W]ord[P]ress/)
                        n1=g1.to_i+10
                        ver1= req2.body[n1,3]
                        print_line("Bitch is Running Wordpress #{ver1}")
			else
			g= (req.body =~ /[V]ersion/)
			n=g.to_i+8
			ver= req.body[n,5]
			print_line("Bitch is Running Wordpress #{ver}")
			end
		end
	end

end
