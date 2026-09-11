import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:resona/core/theme/app_pallete.dart';
import 'package:resona/core/widgets/loader.dart';
import 'package:resona/features/auth/repositories/auth_remote_repositories.dart';
import 'package:resona/features/auth/view-model/auth_viewmodel.dart';
import 'package:resona/features/auth/view/pages/signup_page.dart';
import 'package:resona/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:resona/core/widgets/custom_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resona/features/home/view/pages/upload_song_page.dart';

import '../../../../core/utils.dart';
import '../../../home/view/pages/home_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({
    super.key,
  }); // Flutter sahi widget pehchanta hai Sirf badla hua widget rebuild hota hai Performance better rehti hai
  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // widget hai memory free krne ke liye use hota hai
    emailController.dispose();
    passwordController.dispose();
    super
        .dispose(); // flutter ko btane ke liye hai ki clean ho gya taki vo baki clean kr ske like memory free , setstate band krega , internal listeners htayega etc.
    // formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      authViewmodelProvider.select((val) => val?.isLoading == true),
    );

    ref.listen(authViewmodelProvider, (_, next) {
      next?.when(
        data: (data) {
          showSnackBar(context,'Log in successfully');
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
            (_) => false,
          );
        },
        error: (error, st) {
          showSnackBar(context, error.toString());
        },
        loading: () {},
      );
    });

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(),
        body: isLoading
            ? const Loader()
            : Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sign In',
                        style: TextStyle(
                          color: Pallete.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      CustomField(
                        hintText: 'Enter Email address',
                        controller: emailController,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      CustomField(
                        hintText: 'Enter Password',
                        controller: passwordController,
                        isObsecureText: true,
                      ),

                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      AuthGradientButton(
                        buttonText: 'Sign in',
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            await ref
                                .read(authViewmodelProvider.notifier)
                                .loginUser(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                          } else {
                            showSnackBar(context, 'Missing fields!');
                          }
                        },
                      ),
                      SizedBox(height: 14),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupPage(),
                            ),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            text: 'Don\'t have an account? ',
                            style: Theme.of(context).textTheme.titleMedium,
                            children: const <TextSpan>[
                              TextSpan(
                                text: 'Sign Up',
                                style: TextStyle(
                                  color: Pallete.gradient2,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(height: 50),
                    ],
                  ),
                ),
              ),
      ),
    ); // gives Skeleton to the screen  appbar,drawer,body,floating action button/ bottom navigation bar
  }
}
