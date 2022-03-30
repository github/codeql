require 'rack'
require 'yaml'
require 'openssl'

class RackAppBad
  def call(env)
    req = Rack::Request.new(env)
    password = req.params['password']

    # BAD: Inbound authentication made by comparison to string literal
    if password == 'myPa55word'
      [200, {'Content-type' => 'text/plain'}, ['OK']]
    else
      [403, {'Content-type' => 'text/plain'}, ['Permission denied']]
    end
  end
end

class RackAppGood
  def call(env)
    req = Rack::Request.new(env)
    password = req.params['password']

    config_file = YAML.load_file('config.yml')
    hashed_password = config_file['hashed_password']
    salt = [config_file['salt']].pack('H*')

    #GOOD: Inbound authentication made by comparing to a hash password from a config file.
    hash = OpenSSL::Digest::SHA256.new
    dk = OpenSSL::KDF.pbkdf2_hmac(
      password, salt: salt, hash: hash, iterations: 100_000, length: hash.digest_length
    )
    hashed_input = dk.unpack('H*').first
    if hashed_password == hashed_input
      [200, {'Content-type' => 'text/plain'}, ['OK']]
    else
      [403, {'Content-type' => 'text/plain'}, ['Permission denied']]
    end
  end
end
