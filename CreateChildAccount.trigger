trigger CreateChildAccount on Account (after insert, after update) {
    // Collect parent account ids with a status of "Cold"
    Set<Id> coldParentIds = new Set<Id>();
    
    for (Account prentAccount : Trigger.new) {
        if (prentAccount.Rating__c == 'Cold') {
            coldParentIds.add(prentAccount.Id);
        }
    }
    
    // Create child accounts for the cold parent accounts
    List<Account> childAccountsToInsert = new List<Account>();
    
    for (Account prentAccount : [SELECT Id, Name FROM Account WHERE Id IN :coldParentIds]) {
        Account childAccount = new Account(
            Name = prentAccount.Name,
            ParentId = prentAccount.Id,
            Rating__c = 'Cold'
        );
        
        childAccountsToInsert.add(childAccount);
    }
    
    // Insert child accounts
    if (!childAccountsToInsert.isEmpty()) {
        Database.SaveResult[] saveResults = Database.insert(childAccountsToInsert, false);
        
        // Handle any errors during the insertion of child accounts
        for (Integer i = 0; i < saveResults.size(); i++) {
            if (!saveResults[i].isSuccess()) {
                Database.Error error = saveResults[i].getErrors()[0];
                Trigger.new[i].addError('Error creating child account: ' + error.getMessage());
            }
        }
    }
}