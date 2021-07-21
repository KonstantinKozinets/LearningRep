public class WrapperClass {

    public String wrapperType;
    public String wrapperName;

    public WrapperClass(String wType, String wName){
        wrapperType = wType;
        wrapperName = wName;
    }

    public static Map<String, List<WrapperClass>> WrapperClassMap(List<WrapperClass> wpcls) {
        Map<String, List<WrapperClass>> typesMap = new Map<String, List<WrapperClass>>();
        Set<String> types = new Set<String>();
        List<WrapperClass> listToPut = new List<WrapperClass>();
        for (WrapperClass wrap: wpcls) {
            types.add(wrap.wrapperType);
        }
        for (String typpe: types) {
            for (WrapperClass wrap: wpcls) {
                if (typpe == wrap.wrapperType){
                    listToPut.add(wrap);
                }
            }
            typesMap.put(typpe, listToPut);
            listToPut.clear();
        }
        return typesMap;
    }
}