# StoreHub - Flutter E-commerce App

A comprehensive Flutter application demonstrating **clean architecture**, **BLoC state management**, **real API integration**, and **comprehensive testing** using the FakeStore API.

---

## 🎯 Project Overview

StoreHub is a full-featured e-commerce Flutter application that showcases best practices in:

* Clean Architecture (Data, Domain, Presentation layers)
* BLoC Pattern for state management
* REST API integration
* Comprehensive testing suite (unit, widget, integration)
* Responsive design across devices
* Modern UI/UX patterns with reusable components

---

## 🏗️ Architecture

The project follows **Clean Architecture** principles with separation of concerns:

```
lib/
├── data/                   # Data Layer
│   ├── models/            # Data models
│   ├── repositories/      # Repository implementations
│   └── datasources/       # API services
├── domain/                # Domain Layer
│   ├── entities/          # Business entities
│   ├── repositories/      # Repository interfaces
│   └── usecases/          # Business logic
├── presentation/          # Presentation Layer
│   ├── bloc/              # BLoC state management
│   ├── screens/           # UI screens
│   └── widgets/           # Reusable widgets
├── core/                  # Core utilities
│   └── di/                # Dependency injection
├── theme/                 # App theming
└── routes/                # Navigation routes
```

**Reasoning**:

* This ensures scalability and maintainability.
* Each layer has a single responsibility, making testing easier.
* Presentation is independent of business logic and data sources.

---

## 📦 Dependencies

### Core Dependencies

```yaml
dependencies:
  flutter: ^3.16.0
  flutter_bloc: ^9.1.1          # State management with predictable patterns
  equatable: ^2.0.7             # Simplifies state comparisons
  dio: ^5.4.0                   # Robust HTTP client
  cached_network_image: ^3.3.1  # Efficient image caching
  connectivity_plus: ^6.1.4     # Handles online/offline states
  sizer: ^2.0.15                # Responsive design utilities
  google_fonts: ^6.1.0          # Custom typography
```

### Dev Dependencies

```yaml
dev_dependencies:
  flutter_test: ^3.16.0         # Default Flutter testing
  bloc_test: ^10.0.0            # Simplifies BLoC unit tests
  mockito: ^5.4.5               # Mocking dependencies
  build_runner: ^2.4.15         # Code generation for mocks
```

**Reasoning for package choices**:

* **flutter\_bloc + equatable** → Reliable state management and simpler equality checks.
* **dio** → More control over HTTP requests, interceptors, and error handling compared to `http`.
* **cached\_network\_image** → Improves UX by reducing repeated image loads.
* **connectivity\_plus** → Essential for detecting offline mode.
* **sizer** → Enables percentage-based layouts for true responsiveness.
* **google\_fonts** → Ensures consistent typography across platforms.
* **bloc\_test & mockito** → Provides robust test coverage with mocks and controlled states.

---

## 🛠️ Setup Instructions

### Prerequisites

* Flutter SDK ≥ 3.10
* Dart ≥ 3.0
* Android Studio / VS Code
* Git installed

### Installation

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd storehub
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Generate mocks for testing**

   ```bash
   dart run build_runner build
   ```

4. **Run the app**

   ```bash
   flutter run
   ```

### Run Tests

```bash
# Run all tests
flutter test

# Run unit tests
flutter test test/unit/

# Run widget tests
flutter test test/widget/

# Run integration tests
flutter test integration_test/
```

---

## 📚 API Integration

The app integrates with **FakeStore API**:

* `GET /products` → Fetch all products
* `GET /products/categories` → Fetch categories
* `GET /products/category/{category}` → Fetch by category

This ensures **real-world data handling** without setting up a custom backend.

---

## 🧪 Testing

* **Unit Tests** → Validate repositories, use cases, and models.
* **Widget Tests** → Ensure UI components work as expected (e.g., product cards, search bar).
* **Integration Tests** → Test the full app flow including navigation and API calls.
* **BLoC Tests** → Confirm correct state transitions and error handling.

---

## 🎨 Design System

* **Color Palette** → Neutral base with accent colors for clarity.
* **Typography** → Inter font with scalable sizing (Sizer).
* **UI Components** → Reusable cards, buttons, loaders for consistency.
* **Responsive Layout** → Works across mobile, tablet, and desktop-like screens.

---

## 🔧 State Management

The **BLoC Pattern** ensures:

* Predictable state transitions.
* Separation of UI from business logic.
* Easy unit testing of states/events.

Example:

```dart
class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  // Events: LoadAllProducts, LoadByCategory, Refresh
  // States: Initial, Loading, Loaded, Error
}
```

---

## 🌐 Network Layer

* **Dio Client** handles requests with timeout/retry.
* Centralized API service for cleaner repositories.
* Error handling for:

    * Timeout
    * Network unavailable
    * Server errors (404/500)
    * Data parsing issues

---

## 📱 Responsive Design

* **Sizer** provides device-independent scaling:

```dart
width: 90.w,     // 90% of screen width
height: 50.h,    // 50% of screen height
fontSize: 16.sp, // Scalable pixel
```

---

## 🔍 Performance Optimizations

* **Cached images** → Faster load times.
* **Lazy loading** → ListView builders for performance.
* **Connectivity checks** → Inform users of offline states.
* **Resource disposal** → Avoids memory leaks.

