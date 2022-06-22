param _artifactsLocation string = 'http://myweb.com/' // this isn't valid for our repos

@secure()
param _artifactsLocationSasToken string = 'hard coded token' //this shouldn't be a default (use a param if needed)
