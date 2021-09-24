import 'package:topmenu_app/models/Menu.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MenuHelper {
  static final String nomeTabela = "menu";
  static final MenuHelper _menuHelper = MenuHelper._internal();
  Database? _db;

  factory MenuHelper() {
    return _menuHelper;
  }

  MenuHelper._internal() {}

  get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await inicializarDB();
      return _db;
    }
  }

  _onCreate(Database db, int version) async {
    String sql =
        "CREATE TABLE menu( id INTEGER PRIMARY KEY AUTOINCREMENT, title VARCHAR, bannerUrl TEXT, qrCode VARCHAR, isActive VARCHAR, isActive VARCHAR, updatedAt DATETIME)";
    await db.execute(sql);
  }

  inicializarDB() async {
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, "banco_menus.db");
    var db =
        await openDatabase(localBancoDados, version: 1, onCreate: _onCreate);
    return db;
  }

  salvarMenu(Menu menu) async {
    var bancoDados = await db;
    int resultado = await bancoDados.insert(nomeTabela, menu.toMap());
    return resultado;
  }

  recuperarMenus() async {
    var bancoDados = await db;
    String sql = "SELECT * FROM $nomeTabela ORDER BY data DESC";
    List menus = await bancoDados.rawQuery(sql);
    return menus;
  }
}
