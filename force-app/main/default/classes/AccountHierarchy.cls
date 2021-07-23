    public class AccountHierarchy {

        public static List<Account> AccountParents(Account acc){

            List<Account> allAccs = [SELECT Id, ParentId, Name
                                    FROM Account];
            List<Account> parents = new List<Account>();
            Id currentId = acc.ParentId;
            Boolean top = false;
            do {
                if (currentId != null){
                    for(Account acct: allAccs){
                        if (acct.id == currentId){
                            parents.add(acct);
                            currentId = acct.ParentId;
                        }
                    }
                } else {
                    top = true;
                }
            } while (top != true);
            return parents;
        }

        public static List<Account> AccountSubs(Account acc){
            List<Account> allAccs = [SELECT Id, ParentId, Name
                                    FROM Account];
            List<Account> subs = new List<Account>();
            List<Id> subAccIds = new List<Id> { acc.id };
            Boolean bottom = false;
            integer i = 0;
            do {
                for(Account acct: allAccs){
                    list<Account> checks = new List<Account>();
                    if (acct.ParentId == subAccIds[i]){
                        checks.add(acct);
                        subs.add(acct);
                        subAccIds.add(acct.Id);
                    } else if (checks.size() == 0){
                        bottom = true;
                    }
                }
                i++;
            } while ((bottom != true)||(i<subAccIds.size()));
            return subs;
        }

    public static Map<String,List<Account>> ParentsMap(List<Account> accs){

        Map<String,List<Account>> ParentsTree = new Map<String,List<Account>>();
        for(Account acc: accs){
            List<Account> parents = new List<Account>();
            Id currentId = acc.ParentId;
            Boolean top = false;
            do {
                if (currentId != null){
                    for(Account acct: accs){
                        if (acct.id == currentId){
                            parents.add(acct);
                            currentId = acct.ParentId;
                        }
                    }
                } else {
                    top = true;
                }
            } while (top != true);
			if(parents.IsEmpty() == false){
                ParentsTree.put(acc.Name, parents);
            }
        }
        return ParentsTree;

    }

    public static Map<String,List<Account>> SubsMap(List<Account> accs){

        Map<String,List<Account>> SubsTree = new Map<String,List<Account>>();
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
                SubsTree.put(acc.Name, subs);
            }
        }
        return SubsTree;
    }

}