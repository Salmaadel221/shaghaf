import 'package:flutter/material.dart';
import 'package:shagf/core/app_theme.dart';

class RememberMeSwitch extends StatefulWidget {
  const RememberMeSwitch({Key? key}) : super(key: key);

  @override
  State<RememberMeSwitch> createState() => _RememberMeSwitchState();
}

class _RememberMeSwitchState extends State<RememberMeSwitch> {
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Switch.adaptive(
              value: _rememberMe, 
              onChanged: (newValue) {
                setState(() {
                  _rememberMe = newValue;
                });
              },
              activeColor: AppColors.primaryColor, 
              activeTrackColor: AppColors.primaryColor.withOpacity(0.5),
              inactiveThumbColor: AppColors.hintColor,
              inactiveTrackColor: AppColors.secondaryColor,
            ),
            const Text('Remember Me'),
          ],
        ),

        // TextButton(
        //   onPressed: () {
        //     Navigator.pushNamed(context, AppRoutes.resetPassword);
        //   },
        //   child: const Text(
        //     'Forgot Password?',
        //     style: TextStyle(color: AppColors.primaryColor),
        //   ),
        // ),
      ],
    );
  }
}
