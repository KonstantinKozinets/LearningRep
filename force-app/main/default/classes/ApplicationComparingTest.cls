@isTest
public with sharing class ApplicationComparingTest {
    public ApplicationComparingTest() {
        static testmethod void setupTestData() {
            List<Application> appList = new List<Application>();
            appList.add(new Application('TestApplicationTwo',412));
            appList.add(new Application('TestApplicationOne',534));
            appList.add(new Application('TestApplicationThree',123));

            appList.sort();

            System.debug(appList);

            System.assertEquals(123, appList[0].amount);
            System.assertEquals(412, appList[1].amount);
            System.assertEquals(534, appList[2].amount);

        }

    }
}
