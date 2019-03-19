require 'spec_helper'
require 'securerandom'
require 'stribog'

describe CryptoGost3410 do
  context 'crypto_gost3410' do
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
        let(:another_message) { Faker::Lorem.sentence(2) }
        let(:another_hash) { Stribog::CreateHash.new(another_message.reverse).(size).dec }
        let(:receiver_private_key) { SecureRandom.random_number(1..group.order-1) }
        let(:receiver_public_key) { group.generate_public_key receiver_private_key }
        let(:ukm) { SecureRandom.random_number(2**(size/4)..2**(size/2)-1) }
        let(:sender_vko) { generator.vko(ukm, private_key, receiver_public_key) }
        let(:receiver_vko) { generator.vko(ukm, receiver_private_key, public_key) }
        
        it 'has valid signature' do
          expect(verifier.verify(hash, public_key, signature)).to be_truthy
        end
        
        it 'has invalid signature for changed message' do
           expect(verifier.verify(another_hash, public_key, signature)).to be_falsy
        end
        
        it 'sender VKO equals to receiver VKO' do
          expect((sender_vko.x == receiver_vko.x) && (sender_vko.y == receiver_vko.y)).to be_truthy
        end

      end
    end
  end
end
