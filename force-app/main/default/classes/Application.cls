public class Application implements Comparable {

    private String name;
    private Integer amount;

    public Application(String n, Integer a) {
        name = n;
        amount = a;
    }

    public Integer compareTo(Object compareTo) {
        Application compareToApp = (Application)compareTo;
        if (amount == compareToApp.amount) {
            return 0;
        }
        if (amount > compareToApp.amount) {
            return 1;
        }
        return -1;
    }

}