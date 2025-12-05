import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/profile_screen.dart';

void main() {
  group('ProfileScreen Widget Tests', () {
    testWidgets('renders profile screen with all form fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      // Verify app bar title
      expect(find.text('Profile'), findsOneWidget);

      // Verify section heading
      expect(find.text('Personal Information'), findsOneWidget);

      // Verify all form fields are present
      expect(find.widgetWithText(TextFormField, 'Full Name'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
      expect(
          find.widgetWithText(TextFormField, 'Phone Number'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Delivery Address'),
          findsOneWidget);

      // Verify buttons
      expect(
          find.widgetWithText(ElevatedButton, 'Save Profile'), findsOneWidget);
      expect(
          find.widgetWithText(ElevatedButton, 'Back to Order'), findsOneWidget);
    });

    testWidgets('form fields have correct input types and icons',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      // Verify icons for each field
      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.byIcon(Icons.email), findsOneWidget);
      expect(find.byIcon(Icons.phone), findsOneWidget);
      expect(find.byIcon(Icons.location_on), findsOneWidget);

      // Verify save and back icons
      expect(find.byIcon(Icons.save), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('validates required fields on save',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      // Tap save button without entering any data
      await tester.tap(find.widgetWithText(ElevatedButton, 'Save Profile'));
      await tester.pumpAndSettle();

      // Verify validation error messages appear
      expect(find.text('Name is required'), findsOneWidget);
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Phone number is required'), findsOneWidget);
      expect(find.text('Delivery address is required'), findsOneWidget);
    });

    testWidgets('validates email format', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      // Enter invalid email
      final emailField = find.widgetWithText(TextFormField, 'Email');
      await tester.enterText(emailField, 'invalid-email');

      // Fill other required fields with valid data
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Full Name'), 'John Doe');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Phone Number'), '1234567890');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Delivery Address'),
          '123 Main St');

      // Tap save button
      await tester.tap(find.widgetWithText(ElevatedButton, 'Save Profile'));
      await tester.pumpAndSettle();

      // Verify email validation error
      expect(find.text('Please enter a valid email address'), findsOneWidget);
    });

    testWidgets('validates phone number format', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      // Enter invalid phone number (too short)
      final phoneField = find.widgetWithText(TextFormField, 'Phone Number');
      await tester.enterText(phoneField, '123');

      // Fill other required fields with valid data
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Full Name'), 'John Doe');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'john@example.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Delivery Address'),
          '123 Main St');

      // Tap save button
      await tester.tap(find.widgetWithText(ElevatedButton, 'Save Profile'));
      await tester.pumpAndSettle();

      // Verify phone validation error
      expect(find.text('Please enter a valid phone number (10-11 digits)'),
          findsOneWidget);
    });

    testWidgets('accepts valid phone number with formatting',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      // Enter valid phone with formatting
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Full Name'), 'John Doe');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'john@example.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Phone Number'), '(123) 456-7890');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Delivery Address'),
          '123 Main St');

      // Tap save button
      await tester.tap(find.widgetWithText(ElevatedButton, 'Save Profile'));
      await tester.pumpAndSettle();

      // Verify success message
      expect(find.text('Profile saved successfully'), findsOneWidget);
    });

    testWidgets('shows success message when form is valid',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      // Fill all fields with valid data
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Full Name'), 'John Doe');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'john.doe@example.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Phone Number'), '1234567890');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Delivery Address'),
          '123 Main Street, City, Postcode');

      // Tap save button
      await tester.tap(find.widgetWithText(ElevatedButton, 'Save Profile'));
      await tester.pumpAndSettle();

      // Verify success snackbar appears
      expect(find.text('Profile saved successfully'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('back button navigates to previous screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
                child: const Text('Go to Profile'),
              ),
            ),
          ),
        ),
      );

      // Navigate to profile screen
      await tester.tap(find.text('Go to Profile'));
      await tester.pumpAndSettle();

      // Verify we're on profile screen
      expect(find.text('Profile'), findsOneWidget);

      // Tap back button
      await tester.tap(find.widgetWithText(ElevatedButton, 'Back to Order'));
      await tester.pumpAndSettle();

      // Verify we're back on the previous screen
      expect(find.text('Go to Profile'), findsOneWidget);
      expect(find.text('Profile'), findsNothing);
    });

    testWidgets('app bar back button navigates to previous screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
                child: const Text('Go to Profile'),
              ),
            ),
          ),
        ),
      );

      // Navigate to profile screen
      await tester.tap(find.text('Go to Profile'));
      await tester.pumpAndSettle();

      // Verify we're on profile screen
      expect(find.text('Profile'), findsOneWidget);

      // Tap app bar back button
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // Verify we're back on the previous screen
      expect(find.text('Go to Profile'), findsOneWidget);
      expect(find.text('Profile'), findsNothing);
    });

    testWidgets('address field supports multiline input',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      // Find address field
      final addressField =
          find.widgetWithText(TextFormField, 'Delivery Address');
      expect(addressField, findsOneWidget);

      // Enter multiline text to verify it accepts multiple lines
      await tester.enterText(addressField, '123 Main St\nApt 4B\nCity, ZIP');
      expect(find.text('123 Main St\nApt 4B\nCity, ZIP'), findsOneWidget);
    });

    testWidgets('accepts valid 11-digit phone number',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      // Fill all fields with valid data including 11-digit phone
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Full Name'), 'Jane Smith');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'jane@example.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Phone Number'), '01234567890');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Delivery Address'),
          '456 Oak Ave');

      // Tap save button
      await tester.tap(find.widgetWithText(ElevatedButton, 'Save Profile'));
      await tester.pumpAndSettle();

      // Verify success message (no validation errors)
      expect(find.text('Profile saved successfully'), findsOneWidget);
      expect(find.text('Please enter a valid phone number (10-11 digits)'),
          findsNothing);
    });

    testWidgets('form fields can be edited and retain values',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      // Enter text in name field
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Full Name'), 'Test User');

      // Verify the text was entered
      expect(find.text('Test User'), findsOneWidget);

      // Edit the field again
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Full Name'), 'Updated Name');

      // Verify the text was updated
      expect(find.text('Updated Name'), findsOneWidget);
      expect(find.text('Test User'), findsNothing);
    });
  });
}
