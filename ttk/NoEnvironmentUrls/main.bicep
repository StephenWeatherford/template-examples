param AutomationAccountName string

resource AutomationAccount 'Microsoft.Automation/automationAccounts@2020-01-13-preview' = {
  name: '${AutomationAccountName}'
}
