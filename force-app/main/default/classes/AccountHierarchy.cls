public class AccountHierarchy {

    private static Map<Id, Account> getAccounts {
        get {
            if (getAccounts == null) {
                getAccounts = new Map<Id, Account>([
                    SELECT Id, ParentId, Name, (SELECT Id, ParentId, Name FROM ChildAccounts)
                    FROM Account
                    WHERE ParentId != NULL
                ]);
                List<Id> parentsAdd = new List<Id>();
                for (Account a : getAccounts.values()){
                    if(!getAccounts.containsKey(a.ParentId)){
                        parentsAdd.add(a.ParentId);
                    }
                }
                getAccounts.putAll(new Map<Id, Account>([
                    SELECT Id, ParentId, Name, (SELECT Id, ParentId, Name FROM ChildAccounts)
                    FROM Account
                    WHERE Id IN :parentsAdd
                ]));
            }

            return getAccounts;

        }
        private set;
    }

    public static void addParentIds(List<Account> parents, Id currentId){
        if (getAccounts.containsKey(currentId)){

            Id parentId = getAccounts.get(currentId).ParentId;

            if (parentId != null){
                parents.add(getAccounts.get(parentId));
                addParentIds(parents, parentId);
            }
        }
    }

    public static List<Account> getParents(Id accId){
        List<Account> parents = new List<Account>();

        addParentIds(parents, accId);

        return parents;
    }

    private static void addChildren(List<Account> children, Id accId){
        if (getAccounts.containsKey(accId)){

            for(Account a : getAccounts.get(accId).ChildAccounts){
                children.add(a);
                addChildren(children, a.Id);
            }
        }

    }

    public static List<Account> getChildren(Id accId){
        List<Account> children = new List<Account>();

        addChildren(children, accId);

        return children;

    }

    public static Map<Id,List<Account>> getParents(Set<Id> accs){

        Map<Id,List<Account>> ParentsTree = new Map<Id,List<Account>>();

        for (Id keyId : accs){
            List<Account> parents = getParents(keyId);
            ParentsTree.put(keyId, parents);
        }

        return ParentsTree;

    }

    public static Map<Id,List<Account>> getChildren(Set<Id> accs){

        Map<Id, List<Account>> SubsTree = new Map<Id, List<Account>>();

        for(Id subId : accs){
            List<Account> childs = new List<Account>(getChildren(subId));
            SubsTree.put(subId, childs);
        }

        return SubsTree;

    }

}