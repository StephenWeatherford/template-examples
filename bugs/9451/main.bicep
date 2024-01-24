module m1 'br:mcr.microsoft.com/bicep/compute/availability-set:1.0.1' = { // F12 works
  name: 'm1'
  params: {
    name: 'as1'
  }
}

module m1b 'br/public:compute/availability-set:1.0.1' = { // F12 works
  name: 'm1b'
  params: {
    name: 'as1'
  }
}

module m2 'br/ms:bicep/compute/availability-set:1.0.1' = { // No definition found for 'availability'
  name: 'm2'
  params: {
    name: 'as1'
  }
}

module m3 'br/msbicep:compute/availability-set:1.0.1' = { // No definition found for 'availability'
  name: 'm3'
  params: {
    name: 'as1'
  }
}
