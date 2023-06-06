# Form Builder Phone Field


### Basic use

```dart
FlutterPhoneField(
  name: 'phone_number',
  decoration: const InputDecoration(
    labelText: 'Phone Number',
    hintText: 'Hint',
  ),
  priorityListByIsoCode: ['KE'],
  validator: FormBuilderValidators.compose([
    FormBuilderValidators.required(),
  ]),
),
```

See [pub.dev example tab](https://pub.dev/packages/form_builder_phone_field/example) or [github code](example/lib/main.dart) for more details


