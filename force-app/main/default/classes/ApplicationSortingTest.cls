@isTest
private class ApplicationSortingTest {

<<<<<<< HEAD
    static testmethod void setupTestData() {
        List<Application> appList = new List<Application>();
        integer i = 0;
        integer k = 0;
        integer truecount = 0;
        
        while (i<1000) {
            string order = 'app '+String.valueOf(i);
            integer amoun = Integer.valueof((Math.random() * 10000));
            appList.add(new Application(order,amoun));
            i++;
        }
        
        System.debug(appList);
        appList.sort();
        System.debug(appList);        
        
        while (k<999) {
            if(applist[k].amount<=applist[k+1].amount) {
            	truecount++;
                k++;
            } 
        }
        
        System.Debug('Count of true values while comparison: '+truecount);
        System.AssertEquals(truecount, 999);
        System.AssertEquals(applist.size(), 1000);
=======
    static testmethod void SortingTest() {
        List<Application> appList = new List<Application>();
        appList.add(new Application('TestApplicationTwo',412));
        appList.add(new Application('TestApplicationOne',534));
        appList.add(new Application('TestApplicationThree',123));

        appList.sort();

        System.debug(appList);

        System.assertEquals(123, appList[0].amount);
        System.assertEquals(412, appList[1].amount);
        System.assertEquals(534, appList[2].amount);
>>>>>>> d0ffa91114bbc0235864e581b9f9d25e782332d0

    }

}