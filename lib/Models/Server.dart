import 'package:mongo_dart/mongo_dart.dart';
import 'User.dart';

class Server {
  Future<DbCollection> start() async {
    final db = await Db.create(
        'mongodb+srv://root:Password123@cluster.frmp3.mongodb.net/AppProgrammering3?authSource=admin&retryWrites=true&w=majority');
    await db.open();
    return db.collection('User');
  }

  Future<User> login(String username, String password) async {
    DbCollection coll = await start();
    var result = await coll.findOne(
        where.eq('username', username).and(where.eq('password', password)));
    if (result != null) {
      return User.fromJson(result);
    }
    return new User();
  }

  Future<User> loginWithId(String sid) async {
    ObjectId id = ObjectId.parse(sid);
    DbCollection coll = await start();
    var result = await coll.findOne(where.eq('_id', id));
    if (result != null) {
      return User.fromJson(result);
    }
    return new User();
  }

  Future<User> registerNewUser(User user) async {
    DbCollection coll = await start();
    await coll.insertOne(user.toJson());
    var newUser = await coll.findOne();
    if (newUser != null) {
      return User.fromJson(newUser);
    }
    return new User();
  }
}
