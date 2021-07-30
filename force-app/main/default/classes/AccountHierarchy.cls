public class AccountHierarchy {

    private static Map<Id, Account> getAccounts {
        get {
            if (getAccounts == null) {
                getAccounts = new Map<Id, Account>([
                    SELECT Id, ParentId, Name, (SELECT Id, ParentId, Name FROM ChildAccounts) ChildAcc
                    FROM Account
                ]);
            }
            return getAccounts;
        }
        private set;
    }

    public static List<Account> getParentIds(Id accId){

        Id currentId = getAccounts.get(accId).ParentId;
        List<Account> parents = new List<Account>();
        if(currentId != null){
            parents.add(getAccounts.get(currentId));
            parents.addAll(getParentIds(currentId));
            return parents;
        } else {
            return parents;
        }
    }


     public static List<Account> getChildIds(Id accId){

         List<Account> children = new List<Account>();
         for(Account a : getAccounts.values()){
             if(a.ParentId == accId){
                 children.add(a);
                 children.addAll(getChildIds(a.id));
             }
         }
         return children;

     }

     public static Map<Id,List<Account>> getParentIds(List<Id> accs){

         Map<Id,List<Account>> ParentsTree = new Map<Id,List<Account>>();

         for (Id keyId : accs){
             List<Account> parents = getParentIds(keyId);
             ParentsTree.put(keyId, parents);
         }

         return ParentsTree;

     }

     public static Map<Id,List<Account>> getChildIds(List<Id> accs){

         Map<Id, List<Account>> SubsTree = new Map<Id, List<Account>>();

         for(Id subId : accs){
             List<Account> childs = getChildIds(subId);
             SubsTree.put(subId, childs);
         }

         return SubsTree;
     }

}