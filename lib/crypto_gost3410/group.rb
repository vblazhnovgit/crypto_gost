module CryptoGost3410
  # Group
  #
  # @author vblazhnovgit
  class Group
    attr_reader :opts, :generator, :a, :b, :gx, :gy, :order, :p

    def initialize(opts)
      @opts = opts
      @name = opts.fetch(:name)
      @id = opts[:id]
      @oid = opts[:oid]
      @p = opts[:p]
      @a = opts[:a]
      @b = opts[:b]
      @gx = opts[:gx]
      @gy = opts[:gy]
      @order = opts[:n]
      @cofactor = opts[:h]
      @generator = CryptoGost3410::Point.new self, [gx, gy]
    end

    NAMES = %w[
      Gost256tc26test
      Gost256tc26a
      Gost256tc26b
      Gost256tc26c
      Gost256tc26d
      Gost512tc26test
      Gost512tc26a
      Gost512tc26b
      Gost512tc26c
    ].freeze

    NAMES.each do |name|
      require_relative "./group/#{name.downcase}"
    end

    def generate_public_key(private_key)
      generator * private_key
    end

  end
end
