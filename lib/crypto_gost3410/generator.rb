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

    def call(private_key, rand_val)
      @private_key = private_key
      @rnd = rand_val
      loop do
        #rand_val = SecureRandom.random_number(group.order)
        #puts "    \"#{rand_val.to_s(16)}\","
        @r = r_func()
        s = s_func()
        break new_signature(r: @r, s: s) if !@r.zero? || !s.zero?
      end
    end

    private

    def r_func()
      (group.generator * @rnd).x % group.order
    end

    def s_func()
      mm = @hash % group.order
      if mm == 0 then mm = 1 end
      ii = (@rnd * mm) % group.order
      nn = (@r * @private_key) % group.order
      (nn + ii) % group.order
      #(r_func(rand_val) * private_key + rand_val * @hash) %
      #  group.order
    end

    def new_signature(keys)
      signature_adapter.new(r: keys[:r], s: keys[:s])
    end

  end
end
