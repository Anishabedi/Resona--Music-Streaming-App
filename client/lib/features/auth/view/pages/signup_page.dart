import 'package:flutter/material.dart';
import 'package:resona/core/theme/app_pallete.dart';
import 'package:resona/core/widgets/loader.dart';
import 'package:resona/features/auth/view-model/auth_viewmodel.dart';
import 'package:resona/features/auth/view/pages/login_page.dart';
import 'package:resona/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:resona/core/widgets/custom_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils.dart';

class SignupPage extends ConsumerStatefulWidget{
  const SignupPage({super.key});                // Flutter sahi widget pehchanta hai Sirf badla hua widget rebuild hota hai Performance better rehti hai
  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage>{

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void dispose(){
    nameController.dispose();                    // widget hai memory free krne ke liye use hota hai
    emailController.dispose();
    passwordController.dispose();
    super.dispose();                              // flutter ko btane ke liye hai ki clean ho gya taki vo baki clean kr ske like memory free , setstate band krega , internal listeners htayega etc.
    // formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authViewmodelProvider.select((val) => val?.isLoading == true)) ;

    ref.listen(
      authViewmodelProvider,
        (_,next){
        next?.when(
          data: (data) {
            showSnackBar(context,'Account created successfully. Please Sign in');

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const LoginPage(),
              ),
            );
          },
          error: (error, st) {
            showSnackBar(context,error.toString());
          },
          loading: () {},
        );
      },
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        // appBar: AppBar(),
        body: isLoading
          ? const Loader()
        : SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).viewInsets.bottom,
            ),

          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(
                left:15.0,
                right:15.0,
                bottom:10.0,
                top:20.0,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sign Up',
                      style: TextStyle(
                          color: Pallete.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                          fontStyle: FontStyle.italic
                      ),),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    CustomField(hintText: 'Name',controller: nameController,),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    CustomField(hintText: 'Enter Email address',controller: emailController,),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    CustomField(hintText: 'Enter Password',controller: passwordController,isObsecureText: true,),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    AuthGradientButton(
                          buttonText: 'Sign up',
                          onTap: () async {
                            if(formKey.currentState!.validate()){
                              await ref.read(authViewmodelProvider.notifier).signUpUser(
                              name: nameController.text,
                              email: emailController.text,
                              password: passwordController.text,
                              );
                            }
                          },
                      ),
                    SizedBox(height: 14),

                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context)=> const LoginPage(),)
                        );
                      },
                      child: RichText(text: TextSpan(
                          text: 'Already have an account? ',
                          style: Theme.of(context).textTheme.titleMedium,
                          children: const <TextSpan>[
                            TextSpan(
                                text: 'Sign in',
                                style: TextStyle(
                                  color: Pallete.gradient2,
                                  fontWeight: FontWeight.bold,
                                )
                            ),
                          ]
                      ),
                      ),
                    ),
                    Container(height: 50),
                  ],
                ),
              ),
            ),
          ),
          ),
        ),
      ),
    );// gives Skeleton to the screen  appbar,drawer,body,floating action button/ bottom navigation bar
  }
}




// import 'package:flutter/material.dart';
// import 'package:fpdart/fpdart.dart';
// import 'package:resona/core/theme/app_pallete.dart';
// import 'package:resona/features/auth/repositories/auth_remote_repositories.dart';
// import 'package:resona/features/auth/view/pages/login_page.dart';
// import 'package:resona/features/auth/view/widgets/auth_gradient_button.dart';
// import 'package:resona/features/auth/view/widgets/custom_field.dart';
//
//
// class SignupPage extends StatefulWidget{
//   const SignupPage({super.key});                // Flutter sahi widget pehchanta hai Sirf badla hua widget rebuild hota hai Performance better rehti hai
//   @override
//   State<SignupPage> createState() => _SignupPageState();
// }
//
// class _SignupPageState extends State <SignupPage>{
//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final formKey = GlobalKey<FormState>();
//   @override
//   void dispose(){                         // widget hai memory free krne ke liye use hota hai
//     nameController.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();                   // flutter ko btane ke liye hai ki clean ho gya taki vo baki clean kr ske like memory free , setstate band krega , internal listeners htayega etc.
//     formKey.currentState!.validate();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         appBar: AppBar(),
//           body:Center(
//             child: Padding(
//               padding: const EdgeInsets.all(15.0),
//               child: Form(
//                 key: formKey,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Sign Up',
//                       style: TextStyle(
//                           color: Pallete.whiteColor,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 40,
//                           fontStyle: FontStyle.italic
//                       ),),
//                     SizedBox(
//                       height:20,
//                     ),
//                     CustomField(hintText: 'Name',controller: nameController,),
//                     SizedBox(height: 16,),
//                     CustomField(hintText: 'Enter Email address',controller: emailController,),
//                     SizedBox(height: 16,),
//                     CustomField(hintText: 'Enter Password',controller: passwordController,isObsecureText: true,),
//
//                     SizedBox(height: 15,),
//                     AuthGradientButton(
//                         buttonText: 'Sign up',
//                         onTap: () async {
//                           final res = await AuthRemoteRepositories().signup(
//                               name: nameController.text,
//                               email: emailController.text,
//                               password: passwordController.text
//                           );
//                           final val = switch(res) {
//                             Left(value: final l) => l,
//                             Right(value: final r) => r.toString(),
//                           };
//                           print(val);
//                         },
//                     ),
//                     SizedBox(height: 14),
//
//                     GestureDetector(
//                       onTap: (){
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context)=> const LoginPage(),)
//                         );
//                       },
//                       child: RichText(text: TextSpan(
//                         text: 'Already have an account? ',
//                         style: Theme.of(context).textTheme.titleMedium,
//                         children: const <TextSpan>[
//                           TextSpan(
//                             text: 'Sign In',
//                             style: TextStyle(
//                               color: Pallete.gradient2,
//                               fontWeight: FontWeight.bold,
//                             )
//                           ),
//                         ]
//                       ),
//                       ),
//                     ),
//                     Container(height: 50),
//
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//     );// gives Skeleton to the screen  appbar,drawer,body,floating action button/ bottom navigation bar
//   }
// }
