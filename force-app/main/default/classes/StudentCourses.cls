public class StudentCourses {

    public String cName;
    public Decimal matchPercentage;

    public StudentCourses (String courseName, Decimal matchPercent){

        cName = courseName;
        matchPercentage = matchPercent;

    }

    public static Map<String, List<Preference__c>> getPreferences() {
        Map<Id, Preference__c> getStudents = new Map<Id, Preference__c>([
            SELECT Id, Name, Student__r.Name, Skill__r.Name
            FROM Preference__c
        ]);

        Map<String, List<Preference__c>> getPreferences = new Map<String,List<Preference__c>>();

        for (Id pref : getStudents.keySet()) {
            if (!getPreferences.containsKey(getStudents.get(pref).Student__r.Name)) {
                getPreferences.put(getStudents.get(pref).Student__r.Name, new List<Preference__c> {getStudents.get(pref)});
            } else if (getPreferences.containsKey(getStudents.get(pref).Student__r.Name)) {
                getPreferences.get(getStudents.get(pref).Student__r.Name).add(getStudents.get(pref));
            }
        }

        return getPreferences;
    }

    public static Map<String, List<Discipline__c>> getDisciplines() {
                Map<Id, Discipline__c> getCourses = new Map<Id, Discipline__c>([
                    SELECT Id, Name, Course__r.Name, Skill__r.Name
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

            return getDisciplines;
    }

    public static Decimal getMatchPercent(List<Discipline__c> disciplines, List<Preference__c> preferences) {
        Integer match = 0;

        Set<String> discs = new Set<String>();
        for (Discipline__c dis : disciplines) {
            discs.add(dis.Name);
        }

        for (Preference__c pref : preferences) {
            for (String ds : discs) {
                if (pref.Name == ds) {
                    match++;
                }
            }
        }

        Decimal matchPercent = (match/preferences.size())*100;

        return matchPercent;
    }

    public static Map<String, List<StudentCourses>> getMatchPercent(List<Student__c> students){

        Map<String, List<StudentCourses>> resultMap = new Map<String, List<StudentCourses>>();
        Map<String, List<Preference__c>> preferences = getPreferences();
        Map<String, List<Discipline__c>> disciplines = getDisciplines();

        for (Student__c student : students){
            for (String course : disciplines.keySet()) {
                if (disciplines.containsKey(course)){
                    if (preferences.containsKey(student.Name)){
                        if (!resultMap.containsKey(student.Name)) {
                            resultMap.put(student.Name, new List<StudentCourses>{
                                new StudentCourses(course,
                                    getMatchPercent(disciplines.get(course), preferences.get(student.Name)))
                            });
                        } else if (resultMap.containsKey(student.Name)) {
                            resultMap.get(student.Name).add(new StudentCourses(
                                course, getMatchPercent(disciplines.get(course), preferences.get(student.Name))
                            ));
                        }
                    }
                }
            }
        }

        return resultMap;
    }
}