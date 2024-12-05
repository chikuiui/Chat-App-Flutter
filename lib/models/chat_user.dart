

class ChatUser{

  ChatUser({
     required this.uid,
     required this.name,
     required this.email,
     required this.imageURL,
     required this.lastActive
  });


  final String uid;
  final String name;
  final String email;
  final String imageURL;
  late DateTime lastActive;


  // Factory Constructor.
  // put those firebase json properties into the ChatUser class through json.
  factory ChatUser.fromJSON(Map<String, dynamic> json){
    return ChatUser(
        uid: json['uid'],
        name: json['name'],
        email: json['email'],
        imageURL: json['image'],
        lastActive: json['last_active'].toDate()
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'email' : email,
      'name' : name,
      'last_active' : lastActive,
      'image' : imageURL
    };
  }

  String lastDayActive(){
    return "${lastActive.month}/${lastActive.month}/${lastActive.year}";
  }

  bool wasRecentlyActive(){
    return DateTime.now().difference(lastActive).inHours < 2;
  }




}