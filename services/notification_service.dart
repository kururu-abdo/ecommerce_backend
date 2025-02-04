import 'package:ecommerce_app/database.dart';
import 'package:ecommerce_app/models/notification.dart';

class NotificationService {

NotificationService();
  
final db = Database();
List<Notification> _notitications = [];
Future<List<Notification>>  getNotifications(int user)async{
try {
  final connection = await db.connection;
final result = await connection.query('SELECT * FROM notitications WHERE user_id = ?' ,
[user],
);
if (result.isEmpty) {
  _notitications=[];
}
_notitications = result.map(
  (row)=> Notification.fromJson(row.fields),
).toList();


} catch (e) {

_notitications=[];
}
return _notitications;
}
Future<void>  markRead(int notification)async{
try {
  final connection = await db.connection;
final result = await connection.query('UPDATE notitications  SET is_read = ?   WHERE id = ?' ,
[1, notification],
);


} catch (e) {


}
}
}