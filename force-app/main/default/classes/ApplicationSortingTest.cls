@isTest
private class ApplicationSortingTest {
    @isTest
    static void TestApplicationSorting() {
        List<Application> appList = new List<Application>();
        Integer i = 0;
        Integer k = 0;
        Integer truecount = 0;

        while (i<1000) {
            appList.add(new Application('app '+String.valueOf(i), Integer.valueof((Math.random() * 10000))));
            i++;
        }

        System.debug('*** Start');
        Test.startTest();
        appList.sort();
        Test.stopTest();
        System.debug('*** End');

        while (k<999) {
            if(applist[k].amount<=applist[k + 1].amount) {
            	truecount++;
                k++;
            }
        }

        System.Debug('Count of "true" values while comparison: ' + truecount);
        System.AssertEquals(truecount, 999);
        System.AssertEquals(applist.size(), 1000);

    }

}