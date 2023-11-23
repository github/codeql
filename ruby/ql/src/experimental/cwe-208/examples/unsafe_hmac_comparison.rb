class UnsafeHmacComparison
    def verify_hmac(host, hmac, salt)
      sha1 = OpenSSL::Digest.new('sha1')
      if OpenSSL::HMAC.digest(sha1, salt, host) == hmac
        puts "HMAC verified"
      else
        puts "HMAC not verified"
      end
    end
  end
  