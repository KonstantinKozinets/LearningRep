public class WrapperClass {

    public String wrapperType;
    public String wrapperName;

    public WrapperClass(String wType, String wName){
        wrapperType = wType;
        wrapperName = wName;
    }

    public static Map<String, List<WrapperClass>> WrapperClassMap(List<WrapperClass> wpcls) {

        Map<String, List<WrapperClass>> typesMap = new Map<String, List<WrapperClass>>();
        for (WrapperClass wpcl: wpcls){
            if (typesMap.containsKey(wpcl.wrapperType)) {
                typesMap.get(wpcl.wrapperType).add(wpcl);
            } else {
                typesMap.put(wpcl.wrapperType, new List<WrapperClass> { wpcl });
            }
        }
        return typesMap;
    }
}