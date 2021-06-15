param rgNamePrefix string
param rgEnvList array
param index int
var v10 = concat(rgNamePrefix, '-', rgEnvList[index])

output o string = v10
