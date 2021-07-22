@IsTest
public class WrapperClassTest {
    @isTest
    static void testWrapperMap() {
        List<WrapperClass> wpcls = new List<WrapperClass>();
        List<String> types = new List<String>{'Car','Animal',
                                              'Industry','Language',
                                              'Country','Month',
                                              'City', 'Lake'};
        for(String typpe: types){
            for (Integer i = 0; i < 11; i++){
                string someObject = typpe + String.ValueOf(i);
                wpcls.add(new WrapperClass(typpe, someObject));
            }
        }

        for (WrapperClass variable : wpcls) {
            System.debug(LoggingLevel.INFO, '*** variable ' + variable);
        }
        Map<String,List<WrapperClass>> finalMap = WrapperClass.WrapperClassMap(wpcls);

        for (String key : finalMap.keySet()) {
            System.debug(LoggingLevel.INFO, '*** key ' + key);
            for (WrapperClass variable : finalMap.get(key)) {
                System.debug(LoggingLevel.INFO, '*** variable ' + variable);
            }
        }
    }
}