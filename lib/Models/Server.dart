import 'package:mongo_dart/mongo_dart.dart';
import 'Label.dart';
import 'Note.dart';
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

  Future<bool> addNote(Note note, ObjectId id) async {
    DbCollection coll = await start();
    var result = await coll.update(
        where.eq('_id', id), modify.push("notes", note.toJson()));
    if (result['updatedExisting'] == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> removeNote(Note note, ObjectId id) async {
    DbCollection coll = await start();
    var result = await coll.update(
        where.eq('_id', id), modify.pull("notes", note.toJson()));
    if (result['updatedExisting'] == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> saveUserData(User user) async {
    DbCollection coll = await start();
    var result = await coll.update(where.eq('_id', user.id), user.toJson());
    if (result['updatedExisting'] == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> addLabelToUser(Label label, ObjectId id) async {
    DbCollection coll = await start();
    var result = await coll.update(
        where.eq('_id', id), modify.push("userLabels", label.toJson()));
    if (result['updatedExisting'] == true) {
      return true;
    } else {
      return false;
    }
  }
}
