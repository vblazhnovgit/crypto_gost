module CryptoGost3410
  class Group
    Gost256tc26test = new(
      name: 'gost256tc26test',
      id: 'id-tc26-gost-3410-2012-256-paramSetTest',  # former id-GostR3410-2001-TestParamSet
      oid: '1.2.643.7.1.2.1.1.0',                     # former 1.2.643.2.2.35.0
      der_oid: "\x06\x09\x2a\x85\x03\x07\x01\x02\x01\x01\x00",
      coord_size: 32,
      p: 0x8000000000000000000000000000000000000000000000000000000000000431,
      a: 0x7,
      b: 0x5FBFF498AA938CE739B8E022FBAFEF40563F6E6A3472FC2A514C0CE9DAE23B7E,
      gx: 0x2,
      gy: 0x8E2A8A0E65147D4BD6316030E16D19C85C97F0A9CA267122B96ABBCEA7E8FC8,
      n: 0x8000000000000000000000000000000150FE8A1892976154C59CFC193ACCF5B3,
      h: 1
    )
  end
end
