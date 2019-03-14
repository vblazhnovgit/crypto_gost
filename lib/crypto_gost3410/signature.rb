module CryptoGost3410
  # DigitalSignature
  #
  # @author vblazhnovgit
  class Signature
    attr_reader :r, :s
    
    def initialize(r:, s:)
      @r = r
      @s = s
    end
  end
end
