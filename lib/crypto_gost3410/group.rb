module CryptoGost3410
  # Group
  #
  # @author vblazhnovgit
  class Group
    attr_reader :opts, :generator, :a, :b, :gx, :gy, :order, :p

    def initialize(opts)
      @opts = opts
      @name = opts.fetch(:name)
=begin      
      @id = opts[:id]
      @oid = opts[:oid]
      @der_oid = opts[:der_oid]
=end      
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
    
    def self.findByOid(oid)
      group = nil
      NAMES.each do |name|
        g = Object.const_get("CryptoGost3410::Group::#{name}")
        if g.opts[:oid] == oid then
          group = g
          break
        end
      end
      group
    end

    def self.findByDerOid(der_oid)
      group = nil
      NAMES.each do |name|
        g = Object.const_get("CryptoGost3410::Group::#{name}")
        if g.opts[:der_oid] == der_oid then
          group = g
          break
        end
      end
      group
    end

    def self.findById(id)
      group = nil
      NAMES.each do |name|
        g = Object.const_get("CryptoGost3410::Group::#{name}")
        if g.opts[:id] == id then
          group = g
          break
        end
      end
      group
    end

    def self.findByName(name)
      group = nil
      NAMES.each do |name|
        g = Object.const_get("CryptoGost3410::Group::#{name}")
        if g.opts[:name] == name then
          group = g
          break
        end
      end
      group
    end
    
    def generate_public_key(private_key)
      generator * private_key
    end

  end
end
