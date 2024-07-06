import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/view.dart';

class objectController extends GetxController{
  var objects = List<Objects>().obs;

  @override
  void onInit() {
    super.onInit();
    getObjects();
    print("3333333333 ${objects.length}");
  }

  void getObjects() async{
    await Future.delayed(Duration(seconds: 1));
    List<Objects> allObj=[];
    FirebaseFirestore.instance.collection("Objects").get().then((value) {
      value.docs.forEach((e) {
         allObj.add(Objects(
           id: e["id"],
           image: e['image'],
           roomNO: e['roomNO'],
           state: e['state'],
           kira_tameen: e['kira_tameen'],
           kira_comsyn: e['kira_comsyn'],
           checkOUT: e['checkOUT'],
           checkIN: e['checkIN'],
           amensmoke: e['amensmoke'],
           amenparking: e['amenparking'],
           allowSmoking: e['allowSmoking'],
           amenWIFI: e['amenWIFI'],
           amensecureCamera: e['amensecureCamera'],
           amenpets: e['amenpets'],
           amenHomesafty: e['amenHomesafty'],
           amengarden: e['amengarden'],
           amenAirCondition: e['amenAirCondition'],
           allowPets: e['allowPets'],
           address: e['address'],
           amenTV: e['amenTV'],
           amenheating: e['amenheating'],
           amenbedroom: e['amenbedroom'],
           hostAD_from: e['hostAD_from'],
           amenpool: e['amenpool'],
           price: e['price'],
           objname: e['objname'],
           maxNO_person: e['maxNO_person'],
           information: e['information'],
           hosr_sale_rent: e['hosr_sale_rent'],
           bathroomNO: e['bathroomNO'],
           balcony: e['balcony'],
           hostspace: e['hostspace'],
           objState: e['objState'],
           floorNO: e['floorNO'],
           type: e['type'],
           money_type: e['money_type'],
           rent_time_for: e['rent_time_for'],
           postcode: e['postcode'],
           city: e['city'],
           bedroomNO: e['bedroomNO'],
           ADowner: e['ADowner'],
           ADID: e['ADID'],
           awaiting_approval: e['awaiting_approval'],
           ads_time: e['ads_time']
         ));
         print("444444444444 ${allObj.length}");
      });
    });
    objects.value = allObj;
    print("5555555555555 ${allObj.length}");

  }
}


