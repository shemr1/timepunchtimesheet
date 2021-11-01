class ProjectModel{
  String uid;
  String name;
  String company;
  DateTime startDate;
  DateTime endDate;




  ProjectModel(String uid,String name, String company, DateTime startDate
      );

  ProjectModel.fromJson(Map<String, dynamic> json){
    name = json ['Name'];
    uid = json ['Project UID'];
    company = json ['Company'];
    startDate = json ['Start Date'];

  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data ['Name'] = this.name;
    data ['Employee UID'] = this.uid;
    data ['Company'] = this.company;
    data ['Start Date'] = this.startDate;

  }


}