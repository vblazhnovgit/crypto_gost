module CryptoGost3410
  # DigitalSignature
  #
  # @author vblazhnovgit
  class Verifier
    attr_reader :group, :public_key, :create_hash, :message

    def initialize(hash, group)
      @hash = hash
      @group = group
    end

    def call(public_key, sign)
      @public_key = public_key
      @sign = sign
      r = sign.r
      s = sign.s
      return false if invalid_vector?(r) || invalid_vector?(s)
      (c_param(r, s).x % group.order) == r
    end

    private

    def mod_inv(opt, mod)
      ModularArithmetic.invert(opt, mod)
    end

    def valid_vector?(vector)
      (1...group.order).cover? vector
    end

    def invalid_vector?(vector)
      !valid_vector?(vector)
    end

    def z_param(param)
      param * mod_inv(@hash, group.order) %
        group.order
    end

    def c_param(r, s)
      group.generator * z_param(s) + public_key * z_param(-r)
    end
  end
end
