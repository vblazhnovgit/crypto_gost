require 'spec_helper'
require 'securerandom'
require 'stribog'

describe CryptoGost3410 do
  context 'elliptic curve signature' do
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
      context name do
        let(:group) { Object.const_get("CryptoGost3410::Group::#{name}") }
        let(:private_key) { group.generate_private_key }
        let(:public_key) { group.generate_public_key private_key }
        let(:message) { Faker::Lorem.sentence(3) }
        let(:size) { if name.start_with?("Gost512") then 512 else 256 end }
        let(:hash) { Stribog::CreateHash.new(message).(size).dec }
        let(:generator) { CryptoGost3410::Generator.new(hash, group) }
        let(:signature) { generator.(private_key) }
        let(:verifier) { CryptoGost3410::Verifier.new(hash, group) }

        it 'has valid sign' do
          expect(verifier.(public_key, signature)).to be_truthy
        end

        context 'change message' do
          let(:another_message) { Faker::Lorem.sentence(2) }
          let(:another_hash) { Stribog::CreateHash.new(message).(size).dec }
          let(:verifier) { CryptoGost3410::Verifier.new(another_hash, group) }

          it 'has invalid sign' do
            expect(verifier.(public_key, signature)).to be_falsy
          end
        end
      end
    end
  end
end
