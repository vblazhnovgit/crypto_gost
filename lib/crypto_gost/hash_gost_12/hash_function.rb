module CryptoGost
  module HashGost12
    # Hash function
    #
    # @author WildDima
    class HashFunction
      using CryptoGost::Refinements

      attr_reader :hash_vector

      def initialize(message)
        @message = message
        @n = BinaryVector.new Array.new(512, 0)
        @sum = BinaryVector.new Array.new(512, 0)
      end

      def hashing(digest_length: 512)
        @digest_length = digest_length
        @hash_vector = set_hash_vector digest_length
        # @message, @n, @sum, @hash_vector = message_cut(@message, @n,
        #                                                @sum, @hash_vector)
        # @message = addition_to @message
        # @message = (BinaryVector.new([1]) + @message).addition_to(size: 512)
        @hash_vector = Compression.new(@n, @message, @hash_vector).start

        @n_bv = BinaryVector.from_byte addition_in_ring(@n.to_dec, @message.size, 2**HASH_LENGTH), 
                                       size: 512

        @sum_bv = BinaryVector.from_byte addition_in_ring(@sum.to_dec, @message.to_dec, 2**HASH_LENGTH), 
                                         size: 512

        @hash_vector = Compression.new(BinaryVector.new(Array.new(512, 0)),
                                       @hash_vector,
                                       @n_bv).start

        @hash_vector = Compression.new(BinaryVector.new(Array.new(512, 0)),
                                       @hash_vector,
                                       @sum_bv).start
      end

      private

      # rubocop:disable Metrics/LineLength
      def set_hash_vector(digest_length)
        case digest_length
        when 512
          BinaryVector.new Array.new(512, 0)
        when 256
          BinaryVector.new Array.new(512, 1)
        else
          raise ArgumentError,
                "digest length must be equal to 256 or 512, not #{digest_length}"
        end
      end
      # rubocop:enable Metrics/LineLength

      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/AbcSize
      def message_cut(message, n, sum, hash_vector)
        return message, n, sum, hash_vector
        # if message length, bigger than hash lengt
        message_temp = message.dup
        n_temp = n.dup
        sum_temp = sum.dup
        hash_vector_temp = hash_vector.dup
        while message_temp.size >= HASH_LENGTH / 8
          message_last512 = message_temp[-512..-1]
          hash_vector_temp = compression_func(n_temp,
                                              hash_vector_temp,
                                              message_last512)
          # N = (N + 512) 2**512
          n_temp = addition_in_ring n_temp.to_i, HASH_LENGTH, 2**HASH_LENGTH
          # sum = sum + m 2**512
          sum_temp = addition_in_ring sum_temp.to_i, Vector.elements(message_last512).to_i, 2**HASH_LENGTH
          # remove hashed part of message
          message_temp = message_temp[0..-512]
        end
        [message_temp, n_temp, sum_temp, hash_vector_temp]
      end
      # rubocop:enable Metrics/MethodLength
      # rubocop:ensable Metrics/AbcSize

      # def compression_func(n, hash_vector, message)
      #   vector = lpsx_func n, hash_vector
      #   vector = func_e vector, message
      #   vector = vectors_xor vector, hash_vector
      #   vectors_xor vector, message
      # end

      # def vectors_xor(first_vector, second_vector)
      #   first_vector.xor second_vector
      # end

      # def replacement_pi(vector)
      #   byte_array = []
      #   vector.each_slice(8) { |byte| byte_array << PI[byte.join('').to_i(2)] }
      #   Vector.elements byte_array
      # end

      # def permutation_t(vector)
      #   byte_array = Array.new 64, 0
      #   vector.each_with_index do |byte, index|
      #     byte_array[T[index]] = byte
      #   end
      #   Vector.elements byte_array
      # end

      # def linear_transformation(vector)
      #   new_vector = []
      #   vector.each_slice(8) do |vector8|
      #     bits_string = vector8.map { |b| b.to_s(2) }.join
      #     new_vector += small_linear_transformation(bits_string)
      #   end
      #   Vector.elements new_vector
      # end

      # def small_linear_transformation(vector)
      #   complete_vector = '0' * (64 - vector.length) + vector
      #   indexes = []
      #   result = 0
      #   complete_vector.chars.each_with_index do |bit, index|
      #     indexes << index unless bit.to_i.zero?
      #   end
      #   indexes.each do |index|
      #     result ^= MATRIX_A[index]
      #   end
      #   addition_by_zeros(result.to_s(2), size: 64).chars.map(&:to_i)
      # end

      # def lpsx_func(first_vector, second_vector)
      #   linear_transformation(
      #     permutation_t(
      #       replacement_pi(
      #         vectors_xor(first_vector, second_vector)
      #       )
      #     )
      #   )
      # end

      # def func_e(first_vector, second_vector)
      #   v1 = first_vector.dup
      #   v2 = second_vector.dup
      #   (0..11).each do |index|
      #     v1 = lpsx_func(v1, v2)
      #     v2 = lpsx_func v1,
      #                    Vector.elements(
      #                      addition_by_zeros(
      #                        CONSTANTS_C[index].to_i(16).to_s(2),
      #                        size: 512
      #                      ).chars.map(&:to_i)
      #                    )
      #   end
      #   vectors_xor v1, v2
      # end

      def addition_in_ring(i1, i2, ring)
        (i1 + i2) % ring
      end

      def addition_to(vector, size: 512)
        return vector if size == vector.size
        v = vector.dup
        addition_vector = '0' * (size - (v.length + 1))
        addition_vector += '1'
        Vector.elements v.to_a.unshift(addition_vector.chars.map(&:to_i))
          .flatten
      end

      def addition_by_zeros(vector, size: 512)
        return vector if vector.length == size
        vector.prepend '0' * (size - vector.size)
      end
    end
  end
end
