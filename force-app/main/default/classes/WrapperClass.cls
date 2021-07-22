public class WrapperClass {

    public String wrapperType;
    public String wrapperName;

    public WrapperClass(String wType, String wName){
        wrapperType = wType;
        wrapperName = wName;
    }

    public static Map<String, List<WrapperClass>> WrapperClassMap(List<WrapperClass> wpcls) {

        Map<String, List<WrapperClass>> typesMap = new Map<String, List<WrapperClass>>();
		List<WrapperClass> newTypeList = new List<WrapperClass>();
        for (WrapperClass wpcl: wpcls){
            if(!typesMap.containsKey(wpcl.wrapperType)) {
                List<WrapperClass> typeList = new List<WrapperClass>();
                newTypeList = typeList;
            } else {
                newTypeList.add(wpcl);
            }
            typesMap.put(wpcl.wrapperType, newTypeList);
        }
        return typesMap;
    }
}