@isTest
private class ApplicationSortingTest {

    static testmethod void setupTestData() {
        List<Application> appList = new List<Application>();
        Integer i = 0;
        Integer k = 0;
        Integer truecount = 0;

        while (i<1000) {
            String order = 'app '+String.valueOf(i);
            Integer amoun = Integer.valueof((Math.random() * 10000));
            appList.add(new Application(order,amoun));
            i++;
        }

        System.debug(appList);
        appList.sort();
        System.debug(appList);

        while (k<999) {
            if(applist[k].amount<=applist[k + 1].amount) {
            	truecount++;
                k++;
            }
        }

        System.Debug('Count of "true" values while comparison: '+truecount);
        System.AssertEquals(truecount, 999);
        System.AssertEquals(applist.size(), 1000);

    }

}