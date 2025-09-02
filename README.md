# 🚀 StoreHub - Flutter E-commerce App

A Flutter e-commerce app showcasing **Clean Architecture**, **BLoC state management**, **API integration**, and **testing best practices**.

---

## 📌 Key Features

* 🏗️ **Clean Architecture** → Scalable & maintainable project structure
* 🔄 **BLoC State Management** → Predictable and testable app flow
* 🌐 **API Integration** → Real data with **FakeStore API**
* 🧪 **Comprehensive Testing** → Unit, widget, and integration coverage
* 📱 **Responsive UI** → Works seamlessly across devices

---

## 🛠️ Setup

### Prerequisites

* Flutter SDK ≥ 3.10
* Dart ≥ 3.0
* Android Studio / VS Code
* Git installed

### Installation

```bash
# Clone repository
git clone <repository-url>
cd storehub

# Install dependencies
flutter pub get

# Generate mocks for testing
dart run build_runner build

# Run the app
flutter run
```

### Run Tests

```bash
flutter test                # All tests
flutter test test/unit/     # Unit tests
flutter test test/widget/   # Widget tests
flutter test integration_test/  # Integration tests
```

---

## 📦 Packages Used

```yaml
dependencies:
   flutter_bloc: ^9.1.1          # State management
   equatable: ^2.0.7             # Simplified equality
   dio: ^5.4.0                   # HTTP client
   cached_network_image: ^3.3.1  # Image caching
   connectivity_plus: ^6.1.4     # Network checks
   sizer: ^2.0.15                # Responsive design
   google_fonts: ^6.1.0          # Typography
```

```yaml
dev_dependencies:
   bloc_test: ^10.0.0            # BLoC testing
   mockito: ^5.4.5               # Mocking
   build_runner: ^2.4.15         # Code generation
```

---

## 🤔 Why These Packages?

* **flutter\_bloc + equatable** → Predictable state management, easier testing
* **dio** → Robust HTTP client with interceptors & error handling
* **cached\_network\_image** → Faster image loading & offline support
* **connectivity\_plus** → Detects online/offline state
* **sizer** → Device-independent responsive layouts
* **google\_fonts** → Consistent typography across platforms
* **bloc\_test & mockito** → Strong test coverage with mocks

---

## 📖 Documentation

- [Technical Details](./TECHNICAL_DETAILS.md)
