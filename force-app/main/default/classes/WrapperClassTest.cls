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
                i++;
            }
        }
        System.Debug(wpcls);
        Map<String,List<WrapperClass>> finalMap = WrapperClass.WrapperClassMap(wpcls);
        System.Debug(finalMap);
    }
}