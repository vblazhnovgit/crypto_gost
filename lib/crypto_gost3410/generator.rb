module CryptoGost3410
  # DigitalSignature
  #
  # @author vblazhnovgit
  class Generator
    attr_reader :group, :public_key

    def initialize(group)
      @group = group
    end

    def sign(hash, private_key, rand_val)
      @hash = hash
      @private_key = private_key
      @rnd = rand_val
      loop do
        @r = r_func()
        s = s_func()
        break Point.new(x: @r, y: s) if !@r.zero? || !s.zero?
      end
    end

    private

    def r_func()
      (group.generator * @rnd).x % group.order
    end

    def s_func()
     (@r * @private_key + @rnd * @hash) % group.order
    end

    def vko(ukm, private_key, other_public_key)
      n = (group.cofactor * private_key * ukm) % group.order
      other_public_key * n
    end
    
  end
end
