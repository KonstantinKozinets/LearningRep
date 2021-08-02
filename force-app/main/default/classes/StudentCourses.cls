public class StudentCourses {

    public String cName;
    public Decimal matchPercentage;

    private static Map<String, List<Preference__c>> getPreferences {
        get {
            if (getPreferences == null) {
                Map<Id, Preference__c> getStudents = new Map<Id, Preference__c>([
                    SELECT Name, Student__r.Name, Skill__r.Name
                    FROM Preference__c
                ]);

                Map<String, List<Preference__c>> getPreferences = new Map<String,List<Preference__c>>();

                for (Preference__c pref : getStudents.values()) {
                    if (!getPreferences.containsKey(pref.Student__r.Name)) {
                        getPreferences.put(pref.Student__r.Name, new List<Preference__c> {pref});
                    } else if (getPreferences.containsKey(pref.Student__r.Name)) {
                        getPreferences.get(pref.Student__r.Name).add(pref);
                    }
                }
            }

            return getPreferences;

        }
        private set;
    }

    private static Map<String, List<Discipline__c>> getDisciplines {
        get {
            if (getDisciplines == null) {
                Map<Id, Discipline__c> getCourses = new Map<Id, Discipline__c>([
                    SELECT Name, Course__r.Name, Skill__r.Name
                    FROM Discipline__c
                ]);

                Map<String, List<Discipline__c>> getDisciplines = new Map<String,List<Discipline__c>>();

                for (Discipline__c dis : getCourses.values()) {
                    if (!getDisciplines.containsKey(dis.Course__r.Name)) {
                        getDisciplines.put(dis.Course__r.Name, new List<Discipline__c> {dis});
                    } else if (getDisciplines.containsKey(dis.Course__r.Name)) {
                        getDisciplines.get(dis.Course__r.Name).add(dis);
                    }
                }
            }

            return getDisciplines;

        }
        private set;
    }

    public static Decimal getMatchPercent(List<Discipline__c> disciplines, List<Preference__c> preferences) {
        Integer match;

        for (Discipline__c dis : disciplines) {
            for (Preference__c pref : preferences) {
                if ((dis.Name.equals(pref.Name))&&(dis.Skill__r.Name.equals(pref.Skill__r.Name))) {
                    match++;
                }
            }
        }

        Decimal matchPercent = match/preferences.size();

        return matchPercent;
    }

    public StudentCourses (String courseName, Decimal matchPercent){

        cName = courseName;
        matchPercentage = matchPercent;

    }

    public static Map<String, List<StudentCourses>> getMatchPercent(List<Student__c> students){

        Map<String, List<StudentCourses>> resultMap = new Map<String, List<StudentCourses>>();

        for (Student__c student : students){
            if (getPreferences.containsKey(student.name)) {
                for (String course : getDisciplines.keySet()) {
                    if (!resultMap.containsKey(student.name)) {
                        resultMap.put(student.name, new List<StudentCourses>{
                            new StudentCourses(course,
                                getMatchPercent(getDisciplines.get(student.name), getPreferences.get(course)))
                        });
                    } else if (resultMap.containsKey(student.name)) {
                        resultMap.get(student.name).add(new StudentCourses(
                            course, getMatchPercent(getDisciplines.get(student.name), getPreferences.get(course))
                        ));
                    }
                }
            }
        }

        return resultMap;
    }
}