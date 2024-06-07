module m1 'br/public:avm/res/app-configuration/configuration-store:0.2.1' = {
  // Available: 0.1.0, 0.1.1, 0.2.0, 0.2.1  
}

module m2 'br/public:avm/res/aad/domain-service:0.1.0' = {
  // Available: 0.1.0, 0.2.0
  params: {
    domainName: 'domainName'
  }
}

// Pass
module m2b 'br/public:avm/res/aad/domain-service:0.1.0' = {
  // Available: 0.1.0, 0.2.0
  params: {
    domainName: 'domainName'
  }
}

module m3 'br/public:avm/res/event-grid/domain:0.3.0' = {
  // Available: 0.1.0, 0.1.1, 0.1.2, 0.1.3, 0.1.4, 0.1.5, 0.2.0, 0.2.1, 0.3.0, 0.3.1
}

// Version higher than last known - should pass
module m3a 'br/public:avm/res/event-grid/domain:0.3.5' = {
  // Available: 0.1.0, 0.1.1, 0.1.2, 0.1.3, 0.1.4, 0.1.5, 0.2.0, 0.2.1, 0.3.0, 0.3.1
}

// Version lower than first known - should fail?
module m3b 'br/public:avm/res/event-grid/domain:0.0.0' = {
  // Available: 0.1.0, 0.1.1, 0.1.2, 0.1.3, 0.1.4, 0.1.5, 0.2.0, 0.2.1, 0.3.0, 0.3.1
}

// Version unknown, in middle - should fail?
module m3b 'br/public:avm/res/event-grid/domain:0.1.6' = {
  // Available: 0.1.0, 0.1.1, 0.1.2, 0.1.3, 0.1.4, 0.1.5, 0.2.0, 0.2.1, 0.3.0, 0.3.1
}

module m4 'br/public:avm/res/web/hosting-environment:0.1.0' = {
  // Available: 0.1.0
  params: {
    name: 'name'
    subnetResourceId: 'id'
  }
}

module m5 'br/public:avm/res/web/does-not-exist:0.1.0' = {
  // Available: 0.1.0
}
