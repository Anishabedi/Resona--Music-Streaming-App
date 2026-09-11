import 'package:flutter/material.dart';
import 'package:resona/core/theme/app_pallete.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resona/core/providers/current_user_notifier.dart';
import 'package:resona/core/utils.dart';
import 'package:resona/features/auth/view/pages/login_page.dart';
import '../../../auth/repositories/auth_local_repository.dart';

class AccountPage extends ConsumerStatefulWidget{
  const AccountPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountPageState();
}

class _AccountPageState extends ConsumerState<AccountPage> {
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    final currentUser = ref.read(currentUserNotifierProvider);
    nameController = TextEditingController(text: currentUser?.name ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

    @override
    Widget build(BuildContext context) {
      final currentUser = ref.watch(currentUserNotifierProvider);
      return Scaffold(
        backgroundColor: Pallete.backgroundColor,
        appBar: AppBar(
          backgroundColor: Pallete.backgroundColor,
          title: const Text('Account'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 20,),
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: getAvatarColor(currentUser?.name ?? '?'),
                      child: Text(
                        currentUser != null && currentUser.name.isNotEmpty
                            ? currentUser.name[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 44,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 60),

              // Name field
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 80,
                    child: Text(
                      'Name',
                      style: TextStyle(
                        color: Pallete.whiteColor,
                        fontSize: 19,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      currentUser!.name[0].toUpperCase() + currentUser!.name.substring(1),
                      style: const TextStyle(
                        color: Pallete.whiteColor,
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Divider(color: Pallete.borderColor, height: 1),
              const SizedBox(height: 20),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 80,
                    child: Text(
                      'Email',
                      style: TextStyle(
                        color: Pallete.whiteColor,
                        fontSize: 19,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      currentUser.email,
                      style: const TextStyle(
                        color: Pallete.whiteColor,
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Divider(color: Pallete.borderColor, height: 1),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(authLocalRepositoryProvider).removeToken();
                    ref.read(currentUserNotifierProvider.notifier).removeUser();

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                          (route) => false,
                    );
                    // Logout logic yahan call hoga
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Pallete.borderColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      color: Pallete.whiteColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      );
  }
}

