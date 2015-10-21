module Passwd
	class Ldap
		def initialize(username)
			@username = username
			@ldap_settings = YAML.load_file("../lib/edg-passwd/ldap.yml")
			@ldap_settings[:host] = @ldap_settings['host']
			@ldap_settings[:port] = @ldap_settings['port']
			@ldap_settings[:encryption] = { method: :simple_tls } if @ldap_settings['ssl']
			@dn = "uid=#{@username},#{@ldap_settings['base']}"
		end

		def bind
			puts "Changing password for user #{@username}"
			print "(current) password: "
			password = STDIN.noecho(&:gets).chomp
			@ldap_settings[:auth] =
				{ method: :simple, username: @dn, password: password }

			@ldap = Net::LDAP.new(@ldap_settings)
			@ldap.bind
		end

		def update_passwd
			password = enter_new_password
			unless password
				print "\nSorry, passwords don't match"
			else
				unix = `/opt/local/sbin/slappasswd -s #{password}`.chomp
				samba = OpenSSL::Digest::MD4.hexdigest(password.encode("UTF-16LE")).upcase
				ops = [
					[:replace, :sambaNTPassword, "#{samba}"],
					[:replace, :userPassword, "#{unix}"]
				]
				result = @ldap.modify dn: @dn, operations: ops 
				if result
					print "\nPassword changed"
				else
					print "\nPassword NOT changed"
				end
			end
		end

		def enter_new_password
			print "\nNew password: "
			password1 = STDIN.noecho(&:gets).chomp
			print "\nRetype new password: "
			password2 = STDIN.noecho(&:gets).chomp
			password1 == password2 ? password1 : false
		end

	end
end