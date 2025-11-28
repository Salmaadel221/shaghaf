import 'package:flutter/material.dart';

class RememberMeSwitch extends StatefulWidget {
  final String label;
  const RememberMeSwitch({Key? key , required this.label,}) : super(key: key);

  @override
  State<RememberMeSwitch> createState() => _RememberMeSwitchState();
}

class _RememberMeSwitchState extends State<RememberMeSwitch> {
bool _value = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Switch.adaptive(
              value: _value,
              onChanged: (newValue) {
                setState(() {
                  _value = newValue;
                });
              },
              activeColor: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 4),
            Text(widget.label), 
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
