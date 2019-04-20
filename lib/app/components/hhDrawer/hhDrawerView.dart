import 'package:flutter/material.dart';
import 'package:hnh/app/abstract/view.dart';
import 'package:hnh/app/components/hhDrawer/hhDrawer_controller.dart';
import 'package:hnh/data/repositories/data_authentication_repository.dart';

class HhDrawer extends StatefulWidget {
  final HHDrawerController _controller =
      HHDrawerController(DataAuthenticationRepository());

  @override
  _HhDrawerView createState() => _HhDrawerView(_controller);
}

class _HhDrawerView extends View<HhDrawer> {
  final HHDrawerController _controller;
  _HhDrawerView(this._controller) {
    _controller.initController(scaffoldKey, callHandler);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(key: scaffoldKey, children: [
      Column(
        children: <Widget>[
          header,
          createPageTile('Home', Icons.home, () => _controller.navigate('/home', context)),
          createPageTile('Events', Icons.calendar_today, () => _controller.navigate('/events', context)),
          createPageTile(
              'My Events',
              Icons.calendar_today,
              () => _controller.navigateWithArgs(
                  '/userEvents', context, {'user': _controller.user})),
          Divider(),
          createPageTile('Sponsors', Icons.business, () => _controller.navigate('/sponsors', context)),
          createPageTile('Local', Icons.hotel,
              () => _controller.navigate('/localPlaces', context)),
          Divider(),
          createPageTile('Logout', Icons.exit_to_app, _controller.logout),
        ],
      ),
      version
    ]);
  }

  Widget get version => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Text(
                '${_controller.info}',
                style: TextStyle(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w300,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic),
              )
            ])
          ],
        ),
      );

  UserAccountsDrawerHeader get header => UserAccountsDrawerHeader(
        accountName: Text(
          _controller.user != null ? _controller.user.fullName : 'Guest User',
          style: TextStyle(fontSize: 18.0),
        ),
        accountEmail: Text(
          _controller.user != null ? _controller.user.email : '',
          style: TextStyle(fontSize: 12.0),
        ),
        currentAccountPicture: GestureDetector(
          onTap: () => print("This is the current user"),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
                'https://www.briceallard.com/static/img/logo-main.ef47e8a.png'),
          ),
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/drawer_bg.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.dstATop,
            ),
          ),
        ),
      );

  ListTile createPageTile(String name, IconData icon, [handler]) {
    return ListTile(
      title: Text(
        name,
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),
      ),
      trailing: Icon(
        icon,
        size: 22.0,
      ),
      onTap: handler,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
