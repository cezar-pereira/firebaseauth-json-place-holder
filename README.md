# 🚀 OAuth JSON Placeholder

## 📋 Project Description

**OAuth JSON Placeholder** is a Flutter application that demonstrates an OAuth authentication implementation integrated with Firebase and consumption of the JSON Placeholder API, following Clean Architecture principles and modern development patterns.

### 🎯 Main Objectives

- **Secure Authentication**: Login/logout implementation using Firebase Auth
- **State Management**: Use of BLoC/Cubit for state management
- **Clean Architecture**: Clear separation of responsibilities between UI, Data and Domain layers
- **Comprehensive Testing**: Coverage of unit and integration tests
- **Modular Navigation**: Route system based on modules

### ✨ Main Features

- 🔐 **Authentication System**
  - Email and password login
  - Authentication error handling
  - User session management
  - Logout

- 📱 **User Interface**
  - Login screen
  - Posts list with pagination
  - Post details screen
  - User profile with details


## 🏗️ Project Architecture

### 📐 Project Pattern: Clean Architecture

The project follows **Clean Architecture** principles with clear separation of responsibilities:

```
lib/
├── core/                   # Infrastructure Layer
│   ├── rest_client/        # HTTP Client (Dio)
│   ├── theme/              # Themes and styles
│   ├── utils/              # Utilities and helpers
│   └── validators/         # Input validations
├── modules/                # Application modules
│   ├── auth/               # Authentication Module
│   │   ├── data/           # Data Layer
│   │   ├── domain/         # Domain Layer
│   │   └── presentation/   # Presentation Layer
│   └── post/               # Posts Module
└── shared_module.dart      # Shared module
```

### 🧩 Layer Structure

#### **1. Presentation Layer (UI)**
- **Widgets**: Interface components
- **Pages**: Application screens
- **BLoCs/Cubits**: State management
- **Keys**: Test identifiers

#### **2. Domain Layer (Business Logic)**
- **Entities**: Domain models
- **Repositories**: Data access interfaces
- **Use Cases**: Business logic
- **Failures**: Error handling

#### **3. Data Layer (External Data)**
- **Datasources**: Data sources (API, Firebase)
- **Repository Implementations**: Concrete implementations

#### **4. Core Layer (Infrastructure)**
- **REST Client**: Configurable HTTP client
- **Theme**: Theme system
- **Validators**: Input validations
- **Utils**: Shared utilities

## 📦 Packages Used

### **Main Dependencies**

| Package | Purpose |
|---------|---------|
| **flutter_modular** | Route system and dependency injection |
| **firebase_auth** | OAuth authentication with Firebase |
| **firebase_core** | Firebase base configuration |
| **bloc** | State management |
| **flutter_bloc** | Flutter + BLoC integration |
| **dio** | HTTP client for REST APIs |
| **fpdart** | Functional programming (Either, Option) |
| **equatable** | Object comparison |

### **Development Dependencies**

| Package | Purpose |
|---------|---------|
| **flutter_test** | Unit testing framework |
| **integration_test** | Integration tests |
| **mocktail** | Mocking for tests |
| **flutter_lints** | Linting rules |

## 🚀 Execution Instructions

### **Prerequisites**

- Flutter SDK >=3.8.1 <4.0.0
- Dart SDK >=3.8.1 <4.0.0
- Android Studio / VS Code

### **1. Environment Setup**

```bash
# Clone the repository
git clone <repository-url>
cd oauth_json_place_holder

# Install dependencies
flutter pub get

# Device
Android/iOS emulator or real device
```

### **2. Run the Application**

```bash
# Run in debug mode
flutter run
```

### **3. Run Tests**

```bash
# Run all unit tests
flutter test

# Run integration tests
flutter test integration_test
```

### **4. User for test**

```bash
# E-mail
isis-lagoeiro@tuamaeaquelaursa.com

# Password
123456
```


### **Test Types**

#### **1. Unit Tests**
- **Cubits**: State and transition testing
- **Repositories**: Business logic testing
- **Datasources**: API integration testing
- **Validators**: Validation testing

#### **2. Integration Tests**
- **Post**: Verification of all states of the posts listing page
- **Login**: Validation of all error and success states

#### **3. Widget Tests**
- **Rendering**: UI elements verification
- **Interactions**: Gesture and input testing
- **States**: Different UI states verification
