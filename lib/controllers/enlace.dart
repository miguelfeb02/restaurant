import 'package:get/get.dart';
import 'package:restaurant/controllers/conectivity.dart';
import 'package:restaurant/controllers/controllercats.dart';
import 'package:restaurant/controllers/controllerinsumos.dart';
import 'package:restaurant/controllers/controllerpro.dart';

class NBinding extends Bindings{
 
  @override
  void dependencies() {
    Get.put<GetXNetworkManager>(GetXNetworkManager());
    Get.put<Controllerpro>(Controllerpro());
    Get.put<Controllercats>(Controllercats());
    Get.put<Controllerinsumos>(Controllerinsumos());
    
  }
}