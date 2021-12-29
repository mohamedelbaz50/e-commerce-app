import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/Layouts/app_cubit/app_cubit.dart';
import 'package:shop_app/Layouts/app_cubit/app_states.dart';
import 'package:shop_app/Modules/Login/login_screen.dart';
import 'package:shop_app/Shared/Component/component.dart';
import 'package:shop_app/Shared/Network/Local/cache_helper.dart';

class SettingsScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  String? profileImage;
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit().get(context);
          nameController.text = cubit.loginModel!.data!.name.toString();
          emailController.text = cubit.loginModel!.data!.email.toString();
          phoneController.text = cubit.loginModel!.data!.phone.toString();
          profileImage = cubit.loginModel!.data!.image.toString();
          return Padding(
              padding: const EdgeInsets.all(20),
              child: ConditionalBuilder(
                condition: cubit.loginModel != null,
                builder: (context) => SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        if (state is UpdateUserDataLoadingState)
                          const LinearProgressIndicator(),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: CircleAvatar(
                            child: Image(
                              width: 100,
                              height: 100,
                              image: NetworkImage(profileImage!),
                              fit: BoxFit.cover,
                            ),
                            radius: 50,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        defaultFormField(
                            controller: nameController,
                            type: TextInputType.name,
                            validate: (String value) {
                              if (value.isEmpty) {
                                return "Name Must be Not Empty";
                              }
                            },
                            label: "Name",
                            prefix: Icons.person),
                        const SizedBox(
                          height: 15,
                        ),
                        defaultFormField(
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            validate: (String value) {
                              if (value.isEmpty) {
                                return "Email Must be Not Empty";
                              }
                            },
                            label: "Email",
                            prefix: Icons.email),
                        const SizedBox(
                          height: 15,
                        ),
                        defaultFormField(
                            controller: phoneController,
                            type: TextInputType.phone,
                            validate: (String value) {
                              if (value.isEmpty) {
                                return "Phone Must be Not Empty";
                              }
                            },
                            label: "Phone",
                            prefix: Icons.phone),
                        const SizedBox(
                          height: 15,
                        ),
                        defaultButton(
                            function: () {
                              if (formKey.currentState!.validate()) {
                                AppCubit().get(context).updateUserData(
                                      name: nameController.text,
                                      email: emailController.text,
                                      phone: phoneController.text,
                                    );
                              }
                            },
                            text: "Save Updates"),
                        const SizedBox(
                          height: 15,
                        ),
                        defaultButton(
                            function: () {
                              CacheHelper.removeData(key: "token").then(
                                  (value) => navigateAndFinish(
                                      context, LoginScreen()));
                            },
                            text: "Logout"),
                      ],
                    ),
                  ),
                ),
                fallback: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              ));
        });
  }
}
