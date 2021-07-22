public class WrapperClass {

    public String wrapperType;
    public String wrapperName;

    public WrapperClass(String wType, String wName){
        wrapperType = wType;
        wrapperName = wName;
    }

    public static Map<String, List<WrapperClass>> WrapperClassMap(List<WrapperClass> wpcls) {
        Map<String, List<WrapperClass>> typesMap = new Map<String, List<WrapperClass>>();
        Set<String> types = new Set<String>(wpcls.wrapperType);
        String currentType;
        for (WrapperClass wpcl: wpcls) {
            List<WrapperClass> listToPut = new List<WrapperClass>();
            if (currentType == null) {
                currentType = wpcl.wrapperType;
                if (wpcl.wrapperType == currentType){
                    listToPut.add(wpcl.wrapperName);
                } else {
                    currentType = null;
                }
            }

        }
        for (String typpe: types) {
            List<WrapperClass> listToPut = new List<WrapperClass>();
            for (WrapperClass wrap: wpcls) {
                if (typpe == wrap.wrapperType){
                    listToPut.add(wrap);
                }
            }
            System.debug(LoggingLevel.INFO, '*** listToPut ' + listToPut);
            typesMap.put(typpe, listToPut);
        }
        return typesMap;
    }
}