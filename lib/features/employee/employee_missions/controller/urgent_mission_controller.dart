import 'package:allo_taf/core/utils/icon_path/icon_path.dart';
import 'package:allo_taf/features/employee/employee_missions/data/urgent_mission_model.dart';
import 'package:get/get.dart';

class UrgentMissionController extends GetxController {
  List<UrgentMissionModel> missions = [
    UrgentMissionModel(
      imagePath: IconPath.urgentBag,
      title: "Event Hostess Saturday",
      description: "Akwa · This week",
      amount: 15000,
    ),
    UrgentMissionModel(
      imagePath: IconPath.urgentBag,
      title: "Event Hostess Saturday",
      description: "Akwa · This week",
      amount: 15000,
    ),
    UrgentMissionModel(
      imagePath: IconPath.urgentBag,
      title: "Event Hostess Saturday",
      description: "Akwa · This week",
      amount: 15000,
    ),
  ];
}
