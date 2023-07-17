class MyGroup_Item {
  final String id, name, code, description, created_at;

  MyGroup_Item(
      this.id,
      this.name,
      this.code,
      this.description,
      this.created_at,
      );
}

class JoinGroup_Item {
  final String id, name, code, description, created_at;

  JoinGroup_Item(
      this.id,
      this.name,
      this.code,
      this.description,
      this.created_at,
      );
}


class DiscussionGroup{

  int? id;
  String? groupName;
  String? groupDesc;
  DateTime? createAt;
  String? groupJoinCode;

  DiscussionGroup({
    this.id,
    required this.groupName,
    required this.groupDesc,
     this.createAt,
     this.groupJoinCode
  });

  static List<DiscussionGroup> createdGroups = [
    DiscussionGroup(
        id: 101,
        groupName: 'Data Communication',
        groupDesc: 'groupDesc',
        createAt: DateTime.now(),
        groupJoinCode: '101-MLDA'
    ),

    DiscussionGroup(
        id: 102,
        groupName: 'HCI',
        groupDesc: 'HCI groupDesc',
        createAt: DateTime.now(),
        groupJoinCode: '102-MLDA'
    ),

    DiscussionGroup(
        id: 103,
        groupName: 'Database Concepts',
        groupDesc: 'groupDesc Database Concepts',
        createAt: DateTime.now(),
        groupJoinCode: '103-MLDA'
    ),

    DiscussionGroup(
        id: 104,
        groupName: 'Information System Security',
        groupDesc: 'groupDesc Information System Security',
        createAt: DateTime.now(),
        groupJoinCode: '104-MLDA'
    ),

  ];




}
