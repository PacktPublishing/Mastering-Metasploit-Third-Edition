require 'msf/core'
class Metasploit3 < Msf::Auxiliary
	include Msf::Exploit::Remote::Ftp
	include Msf::Auxiliary::Scanner
	def initialize
		super(
			'Name'        => 'Apex FTP Detector',
			'Description' => '1.1',
			'Author'      => 'Nipun Jaswal',
			'License'     => MSF_LICENSE
		)
		register_options(
			[
				Opt::RPORT(21),
			], self.class)
	end
	def run_host(target_host)
		begin
		res = connect(true, false)
		if(banner)	
		print_status("#{rhost} is running #{banner}")
		end
		disconnect
		end
	end
end
