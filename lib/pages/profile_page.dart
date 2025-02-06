import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuto_flutter_epsi/components/my_bio_box.dart';
import 'package:tuto_flutter_epsi/components/my_input_alert_box.dart';
import 'package:tuto_flutter_epsi/components/my_post_tile.dart';
import 'package:tuto_flutter_epsi/helper/navigate_pages.dart';
import 'package:tuto_flutter_epsi/services/auth/auth_service.dart';

import '../models/user.dart';
import 'package:tuto_flutter_epsi/services/database/database_provider.dart';

/*

Page de profil utilisateur

*/

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({
    super.key,
    required this.uid,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // providers
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  // Controllers
  final bioTextController = TextEditingController();

  // infos de l'utilisateur connectée
  UserProfile? user;
  String currentUserId = AuthService().getCurrentUid();

  // is Loading ?
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    loadUser();
  }

  // Méthode pour récupérer les données de l'utilisateur connecté
  Future<void> loadUser() async {
    // récupère les infos de l'utilisateur
    user = await databaseProvider.userProfile(widget.uid);

    setState(() {
      _isLoading = false;
    });
  }

  /* Methodes pour la biographie */
  // Montrer l'éditeur de la bio
  void _showEditBioBox() {
    showDialog(
      context: context,
      builder: (context) => MyInputAlertBox(
        textController: bioTextController,
        hintText: "Racontez-nous votre vie",
        onPressed: saveBio,
        onPressedText: "Enregistrer",
      ),
    );
  }

  //Enregistrer la bio
  Future<void> saveBio() async {
    setState(() {
      _isLoading = true;
    });

    // MaJ de la bio
    await databaseProvider.updateBio(bioTextController.text);

    // on recharge l'utilisateur
    await loadUser();

    setState(() {
      _isLoading = false;
    });
  }

  // UI
  @override
  Widget build(BuildContext context) {
    // récupère les post de l'utilisateur
    final allUserPosts = listeningProvider.filterUserPosts(widget.uid);

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: Text(_isLoading ? "" : user!.name),
          foregroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: ListView(
          children: [
            Center(
              child: Text(
                _isLoading ? '' : '@${user!.username}',
                // 'Utilisateur',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),

            SizedBox(
              height: 25,
            ),

            // Photo
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.all(25),
                child: Icon(
                  Icons.person,
                  size: 72,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),

            // stats Suivis / Foolower/ Messages postés

            // Bouton Suivre

            // Bio
            // modifier la bio
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Bio",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: _showEditBioBox,
                    child: Icon(
                      Icons.settings,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // afficher la bio
            MyBioBox(
              text: _isLoading ? '...' : user!.bio,
            ),

            Padding(
              padding: const EdgeInsets.only(
                left: 25,
                top: 25,
              ),
              child: Text(
                "Posts",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),

            // Messages postés
            allUserPosts.isEmpty
                ? const Center(
                    child: Text("Aucun post pour l'instant..."),
                  )
                : ListView.builder(
                    itemCount: allUserPosts.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final post = allUserPosts[index];
                      return MyPostTile(
                        post: post,
                        onUserTap: () {},
                        onPostTap: () => goPostPage(context, post),
                      );
                    },
                  ),
          ],
        ));
  }
}
