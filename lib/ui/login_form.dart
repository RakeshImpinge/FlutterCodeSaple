import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:learn_shudh_gurbani/app_themes.dart';
import 'package:learn_shudh_gurbani/bloc/forgotPassword/forgot_password_scaffold.dart';
import 'package:learn_shudh_gurbani/bloc/login/login_bloc.dart';
import 'package:learn_shudh_gurbani/bloc/login/login_state.dart';
import 'package:learn_shudh_gurbani/bloc/signup/signup_scaffold.dart';
import 'package:learn_shudh_gurbani/constants/constants.dart';
import 'package:learn_shudh_gurbani/services/preferenecs.dart';
import 'package:learn_shudh_gurbani/strings.dart';
import 'package:learn_shudh_gurbani/ui/search_screen.dart';
import 'package:learn_shudh_gurbani/utils/assets_name.dart';
import 'package:learn_shudh_gurbani/widgets/textformfield.dart';
import 'package:learn_shudh_gurbani/widgets/widget.dart';
import '../bloc/login/Login_event.dart';


class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);
  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        context.read<LoginBloc>().add(EmailUnfocused());
        FocusScope.of(context).requestFocus(_passwordFocusNode);
      }
    });
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        context.read<LoginBloc>().add(PasswordUnfocused());
      }
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     return backPressGestureDetection(context,BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
      if (state.status.isSubmissionFailure) {
      } else if (state.status.isSubmissionSuccess) {
      }
      },
          builder: (context, state) => Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(AssetsName.ic_logo,width: 140,height: 130,fit: BoxFit.scaleDown),
                      Padding(padding: const EdgeInsets.only(bottom: 15, top: 15),
                        child: Text(Strings.resources, textAlign: TextAlign.center, style: TextStyle(fontSize: 20, color: Theme.of(context).dividerColor),),),//<= resource text
                       _EmailInputField(focusNode: _emailFocusNode),
                       _PasswordInputField(focusNode: _passwordFocusNode),
                        GestureDetector(onTap: (){
                         navigationPage(context,forgotPassword,const ForgotPasswordScaffold());
                       },
                       child:text(Strings.forgot_password,true,Colors.white,18.0,1.0, false,false,context,15,FontWeight.normal),
                       ),
                         const _LoginButton(),
                       const _SignUpButton(),
                    ],
                  ),
                ),
              ),
              state.status.isSubmissionInProgress ? const Positioned(child: Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                ),
              ) : Container(),
            ],
          ),
     ));

  }
}


class _EmailInputField extends StatelessWidget {
  const _EmailInputField({Key? key, required this.focusNode}) : super(key: key);

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return CustomTextField(
              hint: Strings.email,
              padding: 10,
              keyboardType: TextInputType.emailAddress,
              isRequired: true,
              cursorColor: Theme.of(context).indicatorColor,
              fillColor: Theme.of(context).disabledColor,
              textStyle: TextStyle(color: Theme.of(context).indicatorColor, fontSize: 18),
              errorTextStyle: const TextStyle(color: AppThemes.deepPinkColor, fontSize: 16),
              errorColor: AppThemes.deepPinkColor,
              focusNode: focusNode,
              error: state.email.invalid ? Strings.invalidEmail : null,
              onChange: (email)=>{
              context.read<LoginBloc>().add(EmailChanged(email: email.trim()))
              },
              textInputAction: TextInputAction.next,
        );
      },
   );
  }
}

class _PasswordInputField extends StatelessWidget {
  const _PasswordInputField({Key? key, required this.focusNode}) : super(key: key);
  final FocusNode focusNode;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return CustomTextField(
          padding: 15,
          hint: Strings.password,
          isRequired: true,
          cursorColor: Theme.of(context).indicatorColor,
          fillColor: Theme.of(context).disabledColor,
          textStyle: TextStyle(color: Theme.of(context).indicatorColor, fontSize: 18),
          errorTextStyle: const TextStyle(color: AppThemes.deepPinkColor, fontSize: 16),
          errorColor: AppThemes.deepPinkColor,
          focusNode: focusNode,
          error: state.password.invalid ? Strings.invalidPassword : null,
          onChange: (password)=>{
            context.read<LoginBloc>().add(PasswordChanged(password: password.trim()))
          },
          obscureText: true,
          textInputAction: TextInputAction.done,
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 30,left: 30,right: 30),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  elevation: 4,
                  padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20 ),
                  backgroundColor: state.status.isValidated?Theme.of(context).dividerColor:Theme.of(context).dividerColor.withOpacity(0.8),
                  side:  const BorderSide(width: 2.0, color: Colors.amberAccent),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
              child: Text(Strings.login, style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor,fontWeight: FontWeight.w600),
              ),
             onPressed: () =>state.status.isValidated ?
             submitForm(state.email.value,state.password.value,context) :null,
          )
        );
      },
    );
  }
}
 /*
 login functionality
  */
 submitForm(String email, String password,BuildContext context)async{
   try {
     final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
         email: email,
         password: password
     );
     if(credential.user!.emailVerified){
       Preferences.saveUserDetails("${credential.user?.uid}",credential.user?.displayName);
       Navigator.pushReplacement(context, SlideRightRoute(page: SearchGurbani()));
      // navigationPage(context,searchGurbani,const SearchGurbani());
     }else{
       credential.user!.sendEmailVerification();
       showAlert(context, Strings.checkEmailForVerification);
     }
   } on FirebaseAuthException catch (e) {
     if (e.code == 'user-not-found') {
       showAlert(context, "${Strings.noUserFound}\n${e.message}");
     } else if (e.code == 'wrong-password') {
       showAlert(context, "${Strings.wrongPasswordProvided}\n${e.message}");
     }
   }
 }

class _SignUpButton extends StatelessWidget {
  const _SignUpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
        return Padding(padding: const EdgeInsets.only(top: 20,left: 30,right: 30),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  elevation: 4,
                  padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20 ),
                  backgroundColor: Theme.of(context).primaryColor,
                  side: BorderSide(width: 2.0, color: Theme.of(context).dividerColor),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
              child: const Text(Strings.sign_up,
                style: TextStyle(fontSize: 18,color: AppThemes.darkYellowColor,fontWeight: FontWeight.w600),
              ),
              onPressed: () =>  navigationPage(context,signupScreen,const SignupScreen()),
            )
        );
  }
}