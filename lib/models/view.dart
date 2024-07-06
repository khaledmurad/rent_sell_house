import 'package:cloud_firestore/cloud_firestore.dart';

class Objects{
  String id , ADID ,ADowner,address,allowPets,allowSmoking,balcony,checkIN,checkOUT,city,hosr_sale_rent,hostAD_from,hostspace
  ,image,information,kira_comsyn,kira_tameen,maxNO_person,money_type,name_f,objState
  ,postcode,objname,price,rent_time_for,roomNO,service_fee,state,type,awaiting_approval;
  bool amenAirCondition,amenHomesafty,amenTV,amenWIFI,amenbedroom,amengarden,amenheating,
      amenparking,amenpets,amensecureCamera,amensmoke,amenpool;
  int bathroomNO,bedroomNO,floorNO;
  Timestamp ads_time;


  Objects({
    this.id,this.objState,this.state,this.city,this.image,this.bedroomNO,this.amenbedroom,this.amenTV,this.amenheating
  ,this.ADID,this.roomNO,this.postcode,this.hostspace,this.type,this.address,this.ADowner,this.allowPets,this.allowSmoking,this.amenAirCondition
  ,this.amengarden,this.amenHomesafty,this.amenparking,this.amenpets,this.amensecureCamera,this.amensmoke,this.amenWIFI,this.balcony,this.bathroomNO
  ,this.checkIN,this.checkOUT,this.floorNO,this.hosr_sale_rent,this.hostAD_from,this.information,this.kira_comsyn,this.kira_tameen
  ,this.maxNO_person,this.money_type,this.name_f,this.objname,this.price,this.rent_time_for,this.service_fee,this.amenpool,
    this.awaiting_approval,this.ads_time
});

  var objects = List<Objects>();

   getObjects() async {
    await Future.delayed(Duration(seconds: 1));
    List<Objects> allObj=[];
    FirebaseFirestore.instance.collection("Objects").get().then((value) {
      value.docs.forEach((e) {
        allObj.add(Objects(
          id: e["id"],
          image: e['image'],
          roomNO: e['roomNO'],
          service_fee: e['service_fee'],
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
          objname: e['objname'],
          name_f: e['name_f'],
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
          price: e['price'],
        ));
        print("00000000000 ${allObj.length}");
      });
    });
   return objects = allObj;
    print("0101010101 ${objects.length}");

  }
}