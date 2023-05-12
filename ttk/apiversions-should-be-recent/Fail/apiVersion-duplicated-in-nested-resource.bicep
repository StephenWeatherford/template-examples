param location string

resource namespace1_resource 'Microsoft.ServiceBus/namespaces@2018-01-01-preview' = {
  name: 'namespace1'
  location: location
  properties: {
  }
}

resource namespace1_queue1_resource 'Microsoft.ServiceBus/namespaces/queues@2017-04-01' = {
  parent: namespace1_resource
  name: 'queue1'
}

resource namespace1_queue1_rule1_resource 'Microsoft.ServiceBus/namespaces/queues/authorizationRules@2015-08-01' = {
  parent: namespace1_queue1_resource
  name: 'rule1'
}

resource namespace1_queue2_resource 'Microsoft.ServiceBus/namespaces/queues@2017-04-01' = {
  name: 'namespace1/queue1'
}

resource namespace1_queue2_rule2_resource 'Microsoft.ServiceBus/namespaces/queues/authorizationRules@2018-01-01-preview' = {
  parent: namespace1_queue2_resource
  name: 'rule2'
}

resource namespace1_queue2_rule3_resource 'Microsoft.ServiceBus/namespaces/queues/authorizationRules@2017-04-01' = {
  name: 'namespace1/queue2/rule3'
}

resource namespace2_resource 'Microsoft.ServiceBus/namespaces@2018-01-01-preview' = {
  name: 'namespace2'
  location: location

  resource queue1_resource 'queues@2015-08-01' = {
    name: 'queue1'
    location: location

    resource rule1_resource 'authorizationRules@2018-01-01-preview' = {
      name: 'rule1'
    }
  }
}

resource namespace2_queue1_rule2_resource 'Microsoft.ServiceBus/namespaces/queues/authorizationRules@2017-04-01' = {
  name: 'namespace2/queue1/rule2'
}

resource namespace2_queue1_rule3_resource 'Microsoft.ServiceBus/namespaces/queues/authorizationRules@2017-04-01' = {
  parent: namespace2_resource::queue1_resource
  name: 'rule3'
}
