module m1 'br/me:samples/hello-world:1.0.2' = {
  name: 'm1'
  params: {
    name: 'me myself'
  }
}

output greeting string = m1.outputs.greeting
