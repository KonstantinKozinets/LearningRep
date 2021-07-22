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
        Id currentId = acc.Id;
        Boolean bottom = false;
        do {
            if (currentId != null){
                for(Account acct: allAccs){
                    list<Account> checks = new List<Account>();
                    if (acct.ParentId == currentId){
                        checks.add(acct);
                        subs.add(acct);
                        currentId = acct.Id;
                    } else if (checks.size() == 0){
                        bottom = true;
                    }
                }
            } else {
                bottom = true;
            }
        } while (bottom != true);
        return subs;
    }

    public static Map<Id,List<Id>> ParentsMap(List<Account> accs){

        Map<Id,List<Id>> ParentsTree = new Map<Id,List<Id>>();
        for(Account acc: accs){
            List<Id> parents = new List<Id>();
            Id currentId = acc.ParentId;
            Boolean top = false;
            do {
                if (currentId != null){
                    for(Account acct: accs){
                        if (acct.id == currentId){
                            parents.add(acct.id);
                            currentId = acct.ParentId;
                        }
                    }
                } else {
                    top = true;
                }
            } while (top != true);
			if(parents.IsEmpty() == false){
                ParentsTree.put(acc.id, parents);
            }
        }
        return ParentsTree;

    }

    public static Map<Id,List<Id>> SubsMap(List<Account> accs){

        Map<Id,List<Id>> SubsTree = new Map<Id,List<Id>>();
        for(Account acc: accs){
            List<Id> subs = new List<Id>();
            Id currentId = acc.Id;
            Boolean bottom = false;
            do {
            if (currentId != null){
                for(Account acct: accs){
                    list<Account> checks = new List<Account>();
                    if (acct.ParentId == currentId){
                        checks.add(acct);
                        subs.add(acct.Id);
                        currentId = acct.Id;
                    } else if (checks.size() == 0){
                        bottom = true;
                    }
                }
            } else {
                bottom = true;
            }
        	} while (bottom != true);
            if(subs.IsEmpty() == false){
                SubsTree.put(acc.id, subs);
            }
        }
        return SubsTree;

    }

}