import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:learn_shudh_gurbani/utils/assets_name.dart';

import '../app_themes.dart';
import '../bloc/signup/sign_up_bloc.dart';
import '../bloc/signup/sign_up_event.dart';
import '../bloc/signup/sign_up_state.dart';
import '../strings.dart';
import '../widgets/textformfield.dart';
import '../widgets/widget.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);
  @override
  SignUpFormState createState() => SignUpFormState();
}

class SignUpFormState extends State<SignUpForm> {
  static bool checkbox=false;
  final _auth = FirebaseAuth.instance;
  final _userNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _userNameFocusNode.addListener(() {
      if (!_userNameFocusNode.hasFocus) {
        context.read<SignUpBloc>().add(UserNameUnfocused());
        FocusScope.of(context).requestFocus(_emailFocusNode);
      }
    });
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        context.read<SignUpBloc>().add(EmailUnfocused());
        FocusScope.of(context).requestFocus(_passwordFocusNode);
      }
    });
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        context.read<SignUpBloc>().add(PasswordUnfocused());
      }
    });
   }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _userNameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return backPressGestureDetection(context,BlocConsumer<SignUpBloc, SignUpState>(
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
                    Padding(padding: const EdgeInsets.only(top: 10),
                      child: Image.asset(AssetsName.ic_logo, width: 140,
                        height: 130,
                        fit: BoxFit.scaleDown,),
                    ),
                Padding(padding: const EdgeInsets.only(bottom: 15, top: 15),
                  child: Text(Strings.resources,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Theme.of(context).dividerColor),
                  ),
                ),//<= resource text
                    _UserNameInputField(focusNode: _userNameFocusNode),
                    _EmailInputField(focusNode: _emailFocusNode),
                    _PasswordInputField(focusNode: _passwordFocusNode),
                    _TermsAndConditionsField(),
                     const _SignUpButton(),
                  ],
                ),
              ),
            ),

          ],
        ),
   ));
  }
}

class _UserNameInputField extends StatelessWidget {
  const _UserNameInputField({Key? key, required this.focusNode}) : super(key: key);
  final FocusNode focusNode;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return CustomTextField(
            padding: 10,
            hint: Strings.full_name,
            keyboardType: TextInputType.text,
            isRequired: true,
            cursorColor: Theme.of(context).indicatorColor,
            fillColor: Theme.of(context).disabledColor,
            textStyle: TextStyle(color: Theme.of(context).indicatorColor, fontSize: 18),
            errorTextStyle: const TextStyle(color: AppThemes.deepPinkColor, fontSize: 16),
            errorColor: AppThemes.deepPinkColor,
            error: state.name.invalid ? Strings.enterName : null,
            onChange: (name)=>context.read<SignUpBloc>().add(NameChanged(name: name.trim())),
            textInputAction: TextInputAction.next,
        );
      },
    );
  }
}
class _TermsAndConditionsField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.checked != current.checked,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top:10),
             child: Row(
             crossAxisAlignment: CrossAxisAlignment.center,
             mainAxisAlignment: MainAxisAlignment.center,
             children: <Widget>[
              Checkbox(checkColor: Theme.of(context).primaryColor,activeColor: Theme.of(context).primaryColor, fillColor:  MaterialStateProperty.all(Theme.of(context).indicatorColor),
                value: state.checked,
                onChanged: (value) {
                  SignUpFormState.checkbox = value!;
                  BlocProvider.of<SignUpBloc>(context).add(CheckBoxChanged(checked: value));
                },
              ),
               Flexible(child: Text(Strings.terms_conditions, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18, color: Theme.of(context).indicatorColor, fontFamily: Strings.AcuminFont),),),
            ],
          ),
        );
      },
    );
  }
}
class _EmailInputField extends StatelessWidget {
  const _EmailInputField({Key? key, required this.focusNode}) : super(key: key);

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return CustomTextField(
            padding: 10,
            hint: Strings.email,
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
              context.read<SignUpBloc>().add(EmailChanged(email: email.trim()))
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
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return CustomTextField(
              padding: 15,
              hint:Strings.password,
              isRequired: true,
              cursorColor: Theme.of(context).indicatorColor,
              fillColor: Theme.of(context).disabledColor,
              textStyle: TextStyle(color: Theme.of(context).indicatorColor, fontSize: 18),
              errorTextStyle: const TextStyle(color: AppThemes.deepPinkColor, fontSize: 16),
              errorColor: AppThemes.deepPinkColor,
              focusNode: focusNode,
              error: state.password.invalid ? Strings.invalidPassword : null,
              onChange: (password)=>{
                context.read<SignUpBloc>().add(PasswordChanged(password: password.trim()))
              },
              obscureText: true,
              textInputAction: TextInputAction.done,
            );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 30,left: 30,right: 30),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  elevation: 4,
                  padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20 ),
                  backgroundColor: state.status.isValidated?Theme.of(context).dividerColor:Theme.of(context).dividerColor.withOpacity(0.8),
                   side: BorderSide(width: 2.0, color: Theme.of(context).dividerColor),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
              child:Text(Strings.sign_up,
                style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),
              ),
                onPressed:() => state.status.isValidated? SignUpFormState.checkbox
                ?submitForm(state.name.value.trim(),state.email.value.trim(),state.password.value.trim(),context)
                    : showSnackbar(context,Strings.validateTermsAndConditions,Strings.AcuminFont,AppThemes.deepPinkColor)
                    : null,
          ),
        );
      },
    );
  }
  submitForm(String name, String email, String password,BuildContext context) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Theme.of(context).primaryColorDark,
              content: Text(
                Strings.successfullyRegisterMsg,
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: Strings.AcuminFont,
                    color: Theme.of(context).indicatorColor),
              )));
      if(credential.user!=null){

        //---- HERE YOU SEND THE EMAIL

        credential.user!.sendEmailVerification();
        User? user = credential.user;
        user?.updateDisplayName(name); //added this line
      }
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showAlert(context,
           "${Strings.oppsRegistrationFailed} ${Strings.weekPasswordMsg}");
      } else if (e.code == 'email-already-in-use') {
        showAlert(context, "${Strings.oppsRegistrationFailed} \n${e.message}");
      }
    } catch (e) {
      print(e);
      showAlert(context, "${Strings.oppsRegistrationFailed} \n${e}");
    }
    }
  }


