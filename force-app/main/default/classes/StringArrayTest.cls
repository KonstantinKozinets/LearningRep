public class StringArrayTest {

    public static List<String> generateStringArray(Integer numberOfStrings) {
        List<String> tests = new List<String>();

        for (Integer i = 0; i < numberOfStrings; i++) {
            tests.add('Test ' + i);
		}

        return tests;
    }
}