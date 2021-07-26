    public class AccountHierarchy {

        public static List<Account> getParentIds(Id acc){

            List<Account> allAccs = [SELECT Id, ParentId, Name
                                     FROM Account
                                     WHERE ParentId = NULL AND NOT IN [SELECT Id
                                                                       FROM Account
                                                                       WHERE Parent.Id == ParentId]];
            Map<Id,Account> parents = new Map<Id,Account>{acc.id => acc};
            Id currentId;
            for (Account a: allAccs){
                if(a.id = acc){
                    currentId = a.ParentId;
                } else if (a.Id = currentId) {
                    map.put(a.id, a);
                    currentId = a.ParentId;
                }
            }
            return parents.values();
        }

        public static List<Account> getChildIds(Id acc){
            List<Account> allAccs = [SELECT Id, ParentId, Name
                                    FROM Account];
            Map<Id,Account> subAccIds = new Map<Id,Account> {acc => [SELECT Id, ParentId, Name
                                                                     FROM Account
                                                                     WHERE id = :acc]};
            for(Account a: allAccs){
                if (subAccIds.containsKey(a.ParentId)){
                    subAccIds.put(a.id, a);
                }
            }

            return subs.values();
        }

    public static Map<Id,List<Account>> getParentIds(List<Id> accs){

        List<Account> accts = [SELECT Id, ParentId, Name
                               FROM Account
                               WHERE Id IN :accs];
        List<Id> childIds = new List<Id>{accts[0].id};
        Map<Id,List<Account>> ParentsTree = new Map<Id,List<Account>>();
        for (Id keyId : accs){
            for(Account acct : accts){
                if(currentId = acct.id){
                    ParentsTree.get()
                } else {
                    ParentsTree.put(keyId, new List<Account>());
                }
            }
        }

        return ParentsTree;

    }

    public static Map<String,List<Account>> getChildIds(List<Account> accs){

        Map<Id,List<Account>> SubsTree = new Map<Id,List<Account>>();
        for(Account acc: accs){
            List<Account> subs = new List<Account>();
            List<Id> subAccIds = new List<Id> { acc.id };
            Boolean bottom = false;
            integer i = 0;
            do {
                if (subAccIds[i] != null){
                    for(Account acct: accs){
                        list<Account> checks = new List<Account>();
                        if (acct.ParentId == subAccIds[i]){
                            checks.add(acct);
                            subs.add(acct);
                            subAccIds.add(acct.Id);
                        } else if (checks.size() == 0){
                            bottom = true;
                        }
                    }
                } else {
                    bottom = true;
                }
                i++;
        	} while ((bottom != true)||(i<subAccIds.size()));
            if(subs.IsEmpty() == false){
                SubsTree.put(acc.Id, subs);
            }
        }
        return SubsTree;
    }

}