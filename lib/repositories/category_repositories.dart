import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/category_model.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';

class CategoryRepository{
  CollectionReference<CategoryModel> categoryRef = FirebaseService.db.collection("categories")
      .withConverter<CategoryModel>(
    fromFirestore: (snapshot, _) {
      return CategoryModel.fromFirebaseSnapshot(snapshot);
    },
    toFirestore: (model, _) => model.toJson(),
  );
    Future<List<QueryDocumentSnapshot<CategoryModel>>> getCategories() async {
    try {
      var data = await categoryRef.get();
      bool hasData = data.docs.isNotEmpty;
      if(!hasData){
        makeCategory().forEach((element) async {
          await categoryRef.add(element);
        });
      }
      final response = await categoryRef.get();
      var category = response.docs;
      return category;
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<DocumentSnapshot<CategoryModel>>  getCategory(String categoryId) async {
      try{
        print(categoryId);
        final response = await categoryRef.doc(categoryId).get();
        return response;
      }catch(e){
        rethrow;
      }
  }

  List<CategoryModel> makeCategory(){
      return [
        CategoryModel(categoryName: "Chochlate cake", status: "active",
            imageUrl: "https://1.bp.blogspot.com/-LNysU0GPBhM/T3heRl6YvCI/AAAAAAAADZE/ZK3SUGHn8hc/s1600/chocolate-cake.jpg"),
        CategoryModel(categoryName: "Strawberry cake", status: "active",
            imageUrl: "https://dessertswithbenefits.com/wp-content/uploads/2014/04/Strawberry-Cake-e1559009927354.jpg"),
        CategoryModel(categoryName: "Vanilla cake", status: "active",
            imageUrl: "https://th.bing.com/th/id/OIP.rwvI1ftQYS-YzXpbwD8B3wHaLH?pid=ImgDet&rs=1"),
        CategoryModel(categoryName: "Blueberry cake", status: "active",
            imageUrl: "https://th.bing.com/th/id/R.4b658e4477d8a0fdebf51a62f9bc6ce5?rik=f7mvb6HtpfIDHQ&riu=http%3a%2f%2fwww.errenskitchen.com%2fwp-content%2fuploads%2f2014%2f05%2fblueberry-cake-1.jpg&ehk=CmE76KmwWVnUvS61NgKe%2b5o3CXqVJz0LWxa92GLzT7A%3d&risl=&pid=ImgRaw&r=0"),
        CategoryModel(categoryName: "Banana cake", status: "active",
            imageUrl: "https://th.bing.com/th/id/OIP.DwSYjaWG4w_BqgZw22ZmAwAAAA?pid=ImgDet&rs=1"),
      ];
  }



}