import 'package:mongo_dart/mongo_dart.dart';
import 'User.dart';

class Server {
  Future<DbCollection> start() async {
    final db = await Db.create(
        'mongodb+srv://root:Password123@cluster.frmp3.mongodb.net/AppProgrammering3?authSource=admin&retryWrites=true&w=majority');
    await db.open();
    return db.collection('User');
  }

  Future login(String username, String password) async {
    DbCollection coll = await start();
    var result = await coll.findOne(
        where.eq('username', username).and(where.eq('password', password)));
    if (result != null) {
      return result;
    }
    return false;
  }
}
