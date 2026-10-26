require 'openssl'

def certificate_matches_known_hash_bad(certificate, known_hash)
  hash = OpenSSL::Digest.new('SHA1').digest certificate
  hash == known_hash
end

def certificate_matches_known_hash_good(certificate, known_hash)
  hash = OpenSSL::Digest.new('SHA256').digest certificate
  hash == known_hash
end
