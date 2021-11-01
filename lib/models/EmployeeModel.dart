class EmployeeModel{
  String name;
  String uid;
  String email;
 String role;



  EmployeeModel(String uid,String name, String email, String role
  );

  EmployeeModel.fromJson(Map<String, dynamic> json){
    name = json ['Name'];
    uid = json ['Employee UID'];
    role = json ['Role'];
    email = json ['Email'];

  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data ['Name'] = this.name;
    data ['Employee UID'] = this.uid;
    data ['Contact'] = this.role;
    data ['Email'] = this.email;

  }


}