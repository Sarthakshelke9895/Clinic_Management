import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/patient_model.dart';
import '../../patient/patient_form_controller.dart';
import '../../utils/app_colors.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_textfield.dart';

class RegisterPatientScreen extends StatefulWidget {
  final Patient? patient;

  const RegisterPatientScreen({
    super.key,
    this.patient,
  });

  bool get isEdit => patient != null;

  @override
  State<RegisterPatientScreen> createState() =>
      _RegisterPatientScreenState();
}

class _RegisterPatientScreenState
    extends State<RegisterPatientScreen> {

final PatientFormController controller =
PatientFormController();

bool _hasChanges = false;

@override
void initState() {
super.initState();

if (widget.patient != null) {
controller.loadPatient(widget.patient!);
}

controller.nameController.addListener(_markChanged);
controller.phoneController.addListener(_markChanged);
controller.addressController.addListener(_markChanged);
controller.dobController.addListener(_markChanged);
}

void _markChanged() {
if (!widget.isEdit) return;

if (!_hasChanges) {
setState(() {
_hasChanges = true;
});
}
}

Future<bool> _confirmClose() async {
if (!widget.isEdit) return true;

if (!_hasChanges) return true;

final result = await showDialog<bool>(
context: context,
barrierDismissible: false,
builder: (context) {
return AlertDialog(
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(16),
),
title: const Row(
children: [
Icon(
Icons.warning_amber_rounded,
color: Colors.orange,
),
SizedBox(width: 10),
Text("Discard Changes?"),
],
),
content: const Text(
"You have unsaved changes.\n\nDo you want to close without saving?",
),
actions: [
TextButton(
onPressed: () {
Navigator.pop(context, false);
},
child: const Text("Keep Editing"),
),
ElevatedButton(
style: ElevatedButton.styleFrom(
backgroundColor: Colors.red,
),
onPressed: () {
Navigator.pop(context, true);
},
child: const Text(
"Discard",
style: TextStyle(
color: Colors.white,
),
),
),
],
);
},
);

return result ?? false;
}

@override
void dispose() {
controller.dispose();
super.dispose();
}

@override
Widget build(BuildContext context) {
return AnimatedBuilder(
animation: controller,
builder: (context, child) {

return PopScope(
canPop: false,
onPopInvokedWithResult: (didPop, result) async {
if (didPop) return;

final close = await _confirmClose();

if (close && mounted) {
Navigator.pop(context);
}
},
child: Dialog(
elevation: 0,
backgroundColor: Colors.transparent,
insetPadding: const EdgeInsets.all(24),
child: Container(
width: 760,
height: 790,
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(10),
boxShadow: [
BoxShadow(
color: Colors.black.withOpacity(0.08),
blurRadius: 28,
offset: const Offset(0, 12),
),
],
),
clipBehavior: Clip.antiAlias,
child: Column(
children: [

//--------------------------------------------------
// HEADER
//--------------------------------------------------

Container(
padding: const EdgeInsets.symmetric(
horizontal: 24,
vertical: 20,
),
color: AppColors.primary,
child: Row(
children: [

Container(
width: 45,
height: 45,
decoration: BoxDecoration(
color: Colors.white.withOpacity(0.15),
borderRadius:
BorderRadius.circular(4),
),
child: Icon(
widget.isEdit
? Icons.edit_note_rounded
: Icons.person_add_alt_1_rounded,
color: Colors.white,
size: 30,
),
),

const SizedBox(width: 18),

Expanded(
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [

Text(
widget.isEdit
? "Edit Patient"
: "Register Patient",
style: const TextStyle(
color: Colors.white,
fontSize: 18,
fontWeight:
FontWeight.bold,
),
),

const SizedBox(height: 1),

Text(
widget.isEdit
? "Update patient information"
: "Create a new patient profile",
style: TextStyle(
color: Colors.white
.withOpacity(0.85),
fontSize: 12,
),
),
],
),
),

IconButton(
splashRadius: 22,
icon: const Icon(
Icons.close,
color: Colors.white,
),
onPressed: () async {
final close =
await _confirmClose();

if (close && mounted) {
Navigator.pop(context);
}
},
),
],
),
),

//--------------------------------------------------
// FORM
//--------------------------------------------------

Expanded(
child: SingleChildScrollView(
padding: const EdgeInsets.fromLTRB(
28,
24,
28,
24,
),
child: Form(
key: controller.formKey,
child: Column(
children: [

// CONTINUES IN PART 2
//--------------------------------------------------
// INFORMATION CARD
//--------------------------------------------------

Container(
width: double.infinity,
padding: const EdgeInsets.all(8),
decoration: BoxDecoration(
color: AppColors.primary.withOpacity(0.06),
borderRadius: BorderRadius.circular(6),
border: Border.all(
color:
AppColors.primary.withOpacity(0.15),
),
),
child: Row(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [

Icon(
Icons.info_outline_rounded,
color: AppColors.primary,
),

const SizedBox(width: 6),

Expanded(
child: Text(
widget.isEdit
? "Update the patient's information below and click Update Patient to save your changes."
: "Fill in the patient's information below to register the patient into the clinic system.",
style: TextStyle(
color: Colors.grey.shade700,
height: 1.3,
  fontSize: 12,
),
),
),

],
),
),

const SizedBox(height: 10),

Align(
alignment: Alignment.centerLeft,
child: Text(
"Patient Information",
style: TextStyle(
fontSize: 14,
fontWeight: FontWeight.bold,
color: AppColors.primary,
),
),
),

const SizedBox(height: 15),

//--------------------------------------------------
// NAME
//--------------------------------------------------

  AppTextField(
    controller: controller.nameController,
    label: "Patient Name",
    icon: Icons.person,
    validator: controller.validateName,
  ),

  const SizedBox(height: 20),

//--------------------------------------------------
// MOBILE NUMBER
//--------------------------------------------------

  AppTextField(
    controller: controller.phoneController,
    label: "Mobile Number",
    icon: Icons.phone,
    keyboardType: TextInputType.phone,
    inputFormatters: [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(10),
    ],
    validator: controller.validatePhone,
  ),

  const SizedBox(height: 20),

//--------------------------------------------------
// GENDER
//--------------------------------------------------

  DropdownButtonFormField<String>(
    value: controller.gender,
    decoration: InputDecoration(
      labelText: "Gender",
      prefixIcon: const Icon(Icons.people),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    items: const [

      DropdownMenuItem(
        value: "Male",
        child: Text("Male"),
      ),

      DropdownMenuItem(
        value: "Female",
        child: Text("Female"),
      ),

      DropdownMenuItem(
        value: "Other",
        child: Text("Other"),
      ),

    ],
    onChanged: (value) {

      controller.gender = value!;

      _markChanged();

      controller.notifyListeners();

    },
  ),

  const SizedBox(height: 20),

//--------------------------------------------------
// DATE OF BIRTH
//--------------------------------------------------

  AppTextField(
    controller: controller.dobController,
    label: "Date of Birth",
    icon: Icons.calendar_month,
    readOnly: true,
    onTap: () async {

      await controller.selectDOB(context);

      _markChanged();

      controller.notifyListeners();

    },
  ),

  const SizedBox(height: 20),

//--------------------------------------------------
// AGE
//--------------------------------------------------

  AppTextField(
    controller: controller.ageController,
    label: "Age",
    icon: Icons.cake,
    readOnly: true,
  ),

  const SizedBox(height: 20),

//--------------------------------------------------
// ADDRESS
//--------------------------------------------------

  AppTextField(
    controller: controller.addressController,
    label: "Address",
    icon: Icons.location_on,
    maxLines: 3,
  ),
],
),
),
),
),

Divider(
height: 1,
color: Colors.grey.shade300,
),

//--------------------------------------------------
// FOOTER
//--------------------------------------------------

Container(
padding: const EdgeInsets.all(20),
decoration: BoxDecoration(
color: Colors.grey.shade50,
),
child: Row(
children: [



const SizedBox(width: 16),

Expanded(
child: AppButton(
text: widget.isEdit
? "Update Patient"
: "Save Patient",
icon: Icons.save,
isLoading:
controller.isLoading,
onPressed: () async {

// CONTINUES IN PART 3
  final result = widget.isEdit
      ? await controller.updatePatient(
    widget.patient!,
  )
      : await controller.savePatient();

  if (!mounted) return;

  if (result == "success") {

    ScaffoldMessenger.of(context)
        .showSnackBar(

      SnackBar(

        content: Text(

          widget.isEdit
              ? "Patient Updated Successfully"
              : "Patient Registered Successfully",

        ),

        backgroundColor:
        Colors.green,

      ),

    );

    Navigator.pop(
      context,
      true,
    );

  } else {

    ScaffoldMessenger.of(context)
        .showSnackBar(

      SnackBar(

        content: Text(
          result,
        ),

        backgroundColor:
        Colors.red,

      ),

    );

  }

},
),
),

],
),
),

],
),
),
),
);
},
);
}
}