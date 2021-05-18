@secure()
param psNoDefault string

@secure()
param psEmpty string = ''

@secure()
param psNotEmpty string = 'not allowed'

@secure()
param psExpression string = resourceGroup().location

@secure()
param psNewGuid string = newGuid()

@secure()
param psContainsNewGuid string = concat('${psEmpty}${newGuid()}', '')

//@secure()
param pi1 int = 1

@secure()
param poNoDefault object

@secure()
param poEmpty object = {}

@secure()
param poNotEmpty object = {
  abc: 1
}
