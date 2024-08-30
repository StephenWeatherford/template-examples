/* =========== */

param kind 'BlobStorage' | 'BlockBlobStorage' | 'FileStorage' | 'Storage' | 'StorageV2' | string = 'StorageV2'

// 1) as is
param kind1 'BlobStorage' | 'BlockBlobStorage' | 'FileStorage' | 'Storage' | 'StorageV2' | string = 'StorageV2'
// CON: doesn't compile

// 2) with "|string" removed, with comment
// CON: doesn't allow for values other than the ones specified
param kind2 'BlobStorage' | 'BlockBlobStorage' | 'FileStorage' | 'Storage' | 'StorageV2' /* | string */ = 'StorageV2'

// 3) as string with @allowed (ONLY FOR TOP LEVEL, not members inside an array or object) -> won't allow other values
// CON: doesn't allow for values other than the ones specified
@allowed(
  [
    'BlobStorage'
    'BlockBlobStorage'
    'FileStorage'
    'Storage'
    'StorageV2'
    // |string
])
param kind3 string = 'StorageV2'

// 4) as string with comment
// CON: allows all valid values, but doesn't provide completion help
param kind4 string /* 'BlobStorage' | 'BlockBlobStorage' | 'FileStorage' | 'Storage' | 'StorageV2' | string */ = 'StorageV2'






output a string = '${kind}${kind1}${kind2}${kind3}${kind4}'
