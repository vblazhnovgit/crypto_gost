require 'spec_helper'
require 'securerandom'
require 'stribog'

describe CryptoGost3410 do
  context 'elliptic curve signature' do
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
      context name do
        let(:group) { Object.const_get("CryptoGost3410::Group::#{name}") }
        let(:private_key) { SecureRandom.random_number(1..group.order-1) }
        let(:public_key) { group.generate_public_key private_key }
        let(:message) { Faker::Lorem.sentence(3) }
        let(:size) { if name.start_with?('Gost512') then 512 else 256 end }
        let(:hash) { Stribog::CreateHash.new(message.reverse).(size).dec }
        let(:generator) { CryptoGost3410::Generator.new(group) }
        let(:rand_val) { SecureRandom.random_number(1..group.order-1) }
        let(:signature) { generator.sign(hash, private_key, rand_val) }
        let(:verifier) { CryptoGost3410::Verifier.new(group) }

        it 'has valid signature' do
          expect(verifier.verify(hash, public_key, signature)).to be_truthy
        end
        
        context 'change message' do
          let(:another_message) { Faker::Lorem.sentence(2) }
          let(:another_hash) { Stribog::CreateHash.new(another_message.reverse).(size).dec }
          let(:verifier) { CryptoGost3410::Verifier.new(group) }

          it 'has invalid signature' do
            expect(verifier.verify(another_hash, public_key, signature)).to be_falsy
          end
        end
      end
    end
  end
end
