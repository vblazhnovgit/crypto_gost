module CryptoGost3410
  class Group
    Gost256tc26c = new(
      name: 'gost256tc26c',
      id: 'id-tc26-gost-3410-2012-256-paramSetC', # former id-GostR3410-2001-CryptoPro-B-ParamSet
      oid: '1.2.643.7.1.2.1.1.3',               # former 1.2.643.2.2.35.2
      p: 57896044618658097711785492504343953926634992332820282019728792003956564823193,
      a: 57896044618658097711785492504343953926634992332820282019728792003956564823190,
      b: 28091019353058090096996979000309560759124368558014865957655842872397301267595,
      gx: 1,
      gy: 28792665814854611296992347458380284135028636778229113005756334730996303888124,
      n: 57896044618658097711785492504343953927102133160255826820068844496087732066703,
      h: 1
    )
  end
end