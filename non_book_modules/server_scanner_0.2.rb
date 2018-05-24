require 'rex/proto/http'
require 'msf/core'
class Metasploit3 < Msf::Auxiliary
	include Msf::Exploit::Remote::HttpClient
	include Msf::Auxiliary::Scanner
	def initialize
		super(
			'Name'        => 'Server Service Detector',
			'Description' => 'Detects Service On Web Server, Uses GET to Pull Out Information',
			'Author'      => 'Nipun_Jaswal',
			'License'     => MSF_LICENSE
		)
	end
	 def os_fingerprint(response)
                if not response.headers.has_key?('Server')
                        return "Unkown OS (No Server Header)"
                end
                case response.headers['Server']
                when /Win32/, /\(Windows/, /IIS/
                        os = "Windows"
                when /Apache\//
                        os = "*Nix"
                else
                        os = "Unknown Server Header Reporting: "+response.headers['Server']
                end
                return os
        end
	def pb_fingerprint(response)
                if not response.headers.has_key?('X-Powered-By')
                        resp = "No-Response"
		else
                resp = response.headers['X-Powered-By']
		end
		return resp
        end
	def run_host(ip)
		begin
			connect
			res = send_request_raw({'uri' => '/', 'method' => 'GET' })
			return if not res
			os_info=os_fingerprint(res)
			pb=pb_fingerprint(res)
			fp = http_fingerprint()
			print_status("#{ip}:#{rport} is running  #{fp} version And Is Powered By: #{pb} Running On #{os_info}")
		end
	end

end
