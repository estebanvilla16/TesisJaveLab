import 'package:JaveLab/models/usuario.dart';
import 'package:JaveLab/services/auth_service.dart';
import 'package:JaveLab/services/chat_service.dart';
import 'package:JaveLab/services/socket_service.dart';
import 'package:JaveLab/services/usuarios_service.dart';
import 'package:JaveLab/widgets/bottom_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class UsuariosPage extends StatefulWidget {
  const UsuariosPage({Key? key}) : super(key: key);

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final usuariosService = UsuariosService();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  List<Usuario> usuarios = [];

  @override
  void initState() {
    _cargarUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    final usuario = authService.usuario;

    return Scaffold(
      appBar: AppBar(
        title: Text('${usuario.nombre} ${usuario.apellido}'),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app, color: Colors.black87),
          onPressed: () {

            socketService.disconnect();

            Navigator.pushReplacementNamed(context, 'login');
            AuthService.deleteToken();
            

          },
        ),
        actions:  <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 10.0),
            child:(socketService.serverStatus == ServerStatus.Online)  
            ? const Icon(Icons.check_circle, color: Colors.blue, size: 30.0)
            : const Icon(Icons.offline_bolt, color: Colors.red),

          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _cargarUsuarios,
        header: const WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue),
          waterDropColor: Colors.blue,
        ),
        child: listViewUsuarios(),
      ),
      bottomNavigationBar: const BottomMenu(), // Agrega el BottomMenu aquí
    );
  }

  ListView listViewUsuarios() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (_, i) => _usuarioListTile(usuarios[i]),
      separatorBuilder: (_, i) => const Divider(),
      itemCount: usuarios.length,
    );
  }

  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(
      title: Text(usuario.nombre),
      subtitle: Text(usuario.correo),
      leading: CircleAvatar(
        child: Text(usuario.nombre.substring(0, 2)),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: usuario.online ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      onTap:(){
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.usuarioPara = usuario;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }

  _cargarUsuarios() async {
    

    usuarios = await usuariosService.getUsuarios();
    setState(() {
      
    });

    //await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }
}
