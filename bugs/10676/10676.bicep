@secure()
param superSecret string

param containsSecret {
  @
  secretProperty: {
    @secure()
    secretProperty: string
  }
}

var indirectSecret = superSecret

output flagged string = superSecret // warning emitted
output notFlagged string = indirectSecret // no warning emitted
output alsoNotFlagged object = containsSecret.secretProperty // no warning emitted
