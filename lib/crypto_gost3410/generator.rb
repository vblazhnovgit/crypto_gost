module CryptoGost3410
  # DigitalSignature
  #
  # @author vblazhnovgit
  class Generator
    attr_reader :group, :public_key, :signature_adapter, :create_hash

    def initialize(hash, group, signature_adapter: Signature)
      @signature_adapter = signature_adapter
      @hash = hash
      @group = group
    end

    def call(private_key)
      @private_key = private_key
      loop do
        rand_val = SecureRandom.random_number(1..group.order)
        r = r_func(rand_val)
        s = s_func(rand_val, private_key)
        break new_signature(r: r, s: s) if !r.zero? || !s.zero?
      end
    end

    private

    def r_func(rand_val)
      (group.generator * rand_val).x % group.order
    end

    def s_func(rand_val, private_key)
      (r_func(rand_val) * private_key + rand_val * @hash) %
        group.order
    end

    def new_signature(keys)
      signature_adapter.new(r: keys[:r], s: keys[:s])
    end

  end
end
