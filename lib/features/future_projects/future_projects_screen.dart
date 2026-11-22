import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:ovinapp/core/theme/theme.dart';
import 'package:ovinapp/core/widgets/widget.dart';

class FutureProjectsScreen extends StatefulWidget {
  const FutureProjectsScreen({super.key});

  @override
  State<FutureProjectsScreen> createState() => _FutureProjectsScreenState();
}

class _FutureProjectsScreenState extends State<FutureProjectsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();
  File? _selectedImage;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _selectedImage = File(image.path));
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      // En producción, aquí se enviaría a un backend.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.illInk,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: const Text(
            '¡Comentario enviado! Gracias por tu aporte.',
            style: TextStyle(color: AppColors.illPaper),
          ),
        ),
      );
      _commentController.clear();
      setState(() => _selectedImage = null);
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration() {
    OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(color: c, width: w),
    );
    return InputDecoration(
      hintText: 'Contanos tu experiencia o sugerencia',
      hintStyle: const TextStyle(color: AppColors.illInkSoft),
      filled: true,
      fillColor: AppColors.illPaper,
      contentPadding: const EdgeInsets.all(16),
      enabledBorder: border(AppColors.paperBorder),
      focusedBorder: border(AppColors.illInk, 1.5),
      errorBorder: border(AppColors.wrongBorder),
      focusedErrorBorder: border(AppColors.wrongBorder, 1.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const SectionHeader(
            category: 'SIGAMOS CRECIENDO',
            number: '04',
            title: 'Lo que viene',
            subtitle: 'Las buenas ideas crecen en comunidad. Mirá lo próximo y contanos qué pensás.',
            background: AppColors.bgFuture,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildNews(),
                  const SizedBox(height: 28),
                  Text(
                    'Tu opinión',
                    style: AppText.serif.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Dejá un comentario y, si querés, una foto de tu Ovikit.',
                    style: TextStyle(fontSize: 13, color: AppColors.illInkSoft),
                  ),
                  const SizedBox(height: 14),
                  _buildForm(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Panel de novedades ----------
  Widget _buildNews() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.illPaper,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.paperBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.illYellow,
              border: Border.all(color: AppColors.illInk, width: 1.5),
            ),
            child: const Icon(Icons.auto_awesome, color: AppColors.illInk),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Novedades',
                  style: AppText.serif.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Próximamente: integración con sensores de humedad para el kit, nuevos videos de experimentos y más juegos de realidad aumentada.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.45,
                    color: AppColors.illInkSoft,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Formulario ----------
  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _commentController,
            maxLines: 4,
            cursorColor: AppColors.illInk,
            style: const TextStyle(color: AppColors.illInk),
            decoration: _fieldDecoration(),
            validator: (value) => (value == null || value.trim().isEmpty)
                ? 'El comentario es obligatorio'
                : null,
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.illInk,
              backgroundColor: AppColors.illPaper,
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: AppColors.illInk, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            onPressed: _pickImage,
            icon: const Icon(Icons.photo_camera_outlined),
            label: const Text(
              'Adjuntar foto del Ovikit',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          if (_selectedImage != null) ...[
            const SizedBox(height: 14),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(
                    _selectedImage!,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: InkWell(
                    onTap: () => setState(() => _selectedImage = null),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.illPaper,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: AppColors.illInk,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 22),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.illInk,
              foregroundColor: AppColors.illPaper,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            onPressed: _submit,
            icon: const Icon(Icons.send_outlined),
            label: const Text(
              'Enviar',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
