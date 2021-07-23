There is debug code for Execute Anonymous Window:

Account acc = [SELECT Id, Name, ParentId
               FROM Account
			         WHERE Name = 'Second Test Acc'
               LIMIT 1];

List<Account> accs = [SELECT Id, Name, ParentId
                      FROM Account];

List<Account> parents = AccountHierarchy.AccountParents(acc);
List<Account> subs = AccountHierarchy.AccountSubs(acc);
Map<String,List<Account>> parentMap = AccountHierarchy.ParentsMap(accs);
Map<String,List<Account>> subsMap = AccountHierarchy.SubsMap(accs);

System.debug('------------------- Parents and childs for account: Name = ' + acc.Name+'. Id = ' + acc.Id + ' ----------------');
System.debug('Parents:');
integer i = 1;
for(Account par: parents) {
	System.debug('Parent ' + i + ' for this acc: ' + par.Name + '. Id: ' + par.Id);
    i++;
}
System.debug('Childs:');
integer j = 1;
for(Account child: subs) {
	System.debug('Child ' + j + ' for this acc: ' + child.Name + '. Id: ' + child.Id);
    j++;
}
System.debug('---------------------- Maps of Parents and Childs across all Accounts -----------------');
for (String key : parentMap.keySet()) {
	System.debug('---------------- Parents of Acc ' + key + ' ----------------------');
    for (Account acct : parentMap.get(key)) {
    	System.debug('*** Parent Name: ' + acct.Name + '. Id: '+acct.Id);
    }
}
for (String key : subsMap.keySet()) {
	System.debug('---------------- Childs of Acc ' + key + ' ----------------------');
    for (Account acct : subsMap.get(key)) {
    	System.debug('*** Child Name: ' + acct.Name + '. Id: '+acct.Id);
    }
}
System.debug('---------------------------- THE END OF CODE ---------------------------------------------');
