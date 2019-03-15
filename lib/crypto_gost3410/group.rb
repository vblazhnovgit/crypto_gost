module CryptoGost3410
  # Group
  #
  # @author vblazhnovgit
  class Group
    attr_reader :opts, :generator, :a, :b, :gx, :gy, :order, :p

    def initialize(opts)
      @opts = opts
      @name = opts.fetch(:name)
      @p = opts[:p]
      @a = opts[:a]
      @b = opts[:b]
      @gx = opts[:gx]
      @gy = opts[:gy]
      @order = opts[:n]
      @cofactor = opts[:h]
      @generator = CryptoGost3410::Point.new self, [gx, gy]
    end

    NAMES = %w(
      Gost256test
      Gost256cpA
      Gost256cpB
      Gost256cpC
      Gost256tc26A
      Gost512test
      Gost512tc26A
      Gost512tc26B
      Gost512tc26C
    ).freeze

    NAMES.each do |name|
      require_relative "./group/#{name.downcase}"
    end

    def generate_public_key(private_key)
      generator * private_key
    end

    def generate_private_key
      r = 0
      loop do
        r = SecureRandom.random_number(order)
        break if r > 0
      end  
      r
    end
  end
end
