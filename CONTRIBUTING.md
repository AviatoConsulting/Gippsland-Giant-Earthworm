# GGE Installation and Contribution Guide

This guide provides step-by-step instructions to set up and run the GGE project on your local system, as well as how to contribute to the project.

## Installation Steps

- **Clone the Repository**  
   Clone the GGE repository to your local system:

   ```bash
   git clone https://github.com/your-username/giant_gipsland_earthworm.git
   cd giant_gipsland_earthworm
   ```

- **Install Dependencies**  
   Ensure you have Flutter installed, and then fetch the necessary packages:

   ```bash
   flutter pub get
   ```

- **Connect to Firebase**  
   Use the [`flutterfire`](https://firebase.flutter.dev/docs/cli/) CLI to connect your Flutter project to Firebase. If you haven't installed `flutterfire`, you can install it using the following command:

   ```bash
   dart pub global activate flutterfire_cli
   ```

   Once `flutterfire` is installed, configure your Firebase project by running:

   ```bash
   flutterfire configure
   ```

   Follow the prompts to select your Firebase project and platforms, and `flutterfire` will automatically generate the required configuration files.

   - **Ensure `firebase_options.dart` is generated** in your project files.
   - Make sure `google-services.json` is added in `android/app` and `GoogleService-Info.plist` is added in `ios/Runner`.

- **Google Sign-In Configuration**  
   To enable Google Sign-In, add the following configuration in your `Info.plist` for iOS:

   ```xml
   <key>GIDClientID</key>
   <!-- Copied from GoogleService-Info.plist key CLIENT_ID -->
   <string>YOUR_CLIENT_ID_HERE</string>
   <key>CFBundleURLTypes</key>
   <array>
       <dict>
           <key>CFBundleTypeRole</key>
           <string>Editor</string>
           <key>CFBundleURLSchemes</key>
           <array>
               <!-- Copied from GoogleService-Info.plist key REVERSED_CLIENT_ID -->
               <string>YOUR_REVERSED_CLIENT_ID_HERE</string>
           </array>
       </dict>
   </array>
   ```

- **Google Maps API Key Setup**  
   Add the Google Maps API keys to enable map functionality:

   - **For Android**: Add the API key in `AndroidManifest.xml` located at `android/app/src/main`.
   - **For iOS**: Add the API key in `AppDelegate.swift` located at `ios/Runner`.

   You can refer to the [Google Maps Flutter package](https://pub.dev/packages/google_maps_flutter) for further details.

- **Run the App**  
   Use Flutter to run the app on an emulator or connected device:

   ```bash
   flutter run
   ```

# How to Get a Google Maps API Key

To get a Google Maps API key, follow these steps:

### Step 1: Go to the Google Cloud Console
- Open the [Google Cloud Console](https://console.cloud.google.com/).
- Sign in with your Google account if you haven't already.

### Step 2: Create a New Project (or Select an Existing Project)
- In the top menu, click on the project dropdown.
- Click on **New Project** if you want to create a new project, then give it a name and click **Create**.
- If you already have a project, select it from the list.

### Step 3: Enable Google Maps API Services
- With your project selected, go to the **Library** tab in the left-hand menu.
- Search for **Maps JavaScript API**, **Places API**, and **Geocoding API** (if you need more location functionalities).
- Click on each API and then click **Enable**.

### Step 4: Generate an API Key
- In the left-hand menu, go to **APIs & Services** > **Credentials**.
- Click **Create Credentials** and select **API Key**.
- Google will generate an API key for you. Copy this key as you’ll need it to configure your app.

### Step 5: Add the API Key to Your Flutter Project
- **For Android**: Open `AndroidManifest.xml` located in `android/app/src/main`, and add your API key within the `<application>` tag:

   ```xml
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="YOUR_API_KEY_HERE" />
   ```

- **For iOS**: Open `AppDelegate.swift` in `ios/Runner`, and add your API key in the `didFinishLaunchingWithOptions` function:

   ```swift
   import GoogleMaps

   @UIApplicationMain
   class AppDelegate: FlutterAppDelegate {
       override func application(
           _ application: UIApplication,
           didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
       ) -> Bool {
           GMSServices.provideAPIKey("YOUR_API_KEY_HERE")
           return super.application(application, didFinishLaunchingWithOptions: launchOptions)
       }
   }
   ```

### Additional Resources
- [Google Maps Platform Documentation](https://developers.google.com/maps/documentation)
- [Google Maps Flutter package](https://pub.dev/packages/google_maps_flutter)

---

## Contributing to GGE

We welcome contributions to the GGE project! Please follow the steps below to make a contribution:

- **Create a New Branch**  
   Create a new branch for your issue or contribution. Naming the branch based on the feature or issue number is recommended (e.g., `feature/observation-tracking` or `bugfix/location-accuracy`).

   ```bash
   git checkout -b your-branch-name
   ```

- **Make Your Changes**  
   Add the feature or fix the bug. Ensure your code is clean and tested before committing.

- **Commit and Push**  
   Commit your changes with a descriptive message and push your branch to the repository.

   ```bash
   git add .
   git commit -m "Describe your changes here"
   git push origin your-branch-name
   ```

- **Submit a Pull Request (PR)**  
   Go to the GitHub repository and submit a pull request. In the PR description, include details about the changes you made, such as the feature added, bug fixed, or improvements made. Please provide any necessary context to help the reviewers understand your contribution.

---

This README provides an overview of the GGE app, highlights its key features and tech stack, and outlines the steps for installation, Firebase connection, and contribution. We appreciate your support in helping us improve the GGE app!
