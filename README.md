# Next to Go

A SwiftUI app that displays a live-updating list of upcoming races with filtering support and countdowns. Built using a modular MVVM architecture with a focus on testability and code clarity.

---

## ✅ Requirements

* Display a time-ordered list of races by advertised start (ascending).
* Exclude races that are one minute past the advertised start.
* Allow filtering by race categories: Horse, Harness, and Greyhound.
* Allow deselecting all filters to show the next 5 races from all categories.

  * Mimics the website logic, where deselecting all filters reselects all.
* Display meeting name, race number, and advertised start as a countdown.
* Always display 5 races, with automatic data refresh.

  * Note: The API may sometimes return fewer than 5 races, especially after filtering.
  * A more accurate requirement might be "at least 5 races" unless another API supports filtered results more effectively.

![Light mode](Screenshots/light-mode-1.png?raw=true)
![Light mode filters](Screenshots/light-mode-2.png?raw=true)
![Dark mode](Screenshots/dark-mode-1.png?raw=true)
![Dark mode filters](Screenshots/dark-mode-2.png?raw=true)

---

## 🧱 Architecture

This project follows the **MVVM** architecture, which is widely adopted in SwiftUI and supports clear separation of concerns and easy testability.

* **Dependency Injection**: Dependencies are injected directly into the ViewModel for simplicity. In a larger app, I’d consider a more robust solution such as:

  * `@Environment`
  * `@Dependency` (as used in TCA)
  
* **Scalability Consideration**: If more time were available, I would likely adopt **The Composable Architecture (TCA)**. It provides first-class support for SwiftUI, dependency injection, and state management, making it ideal for complex and scalable apps.

---

## 📦 Package Structure

* I generally prefer a **single Swift Package** per app to consolidate dependencies and promote thoughtful reuse of logic and components.
* For this project, I’ve opted to **directly import two local packages** into Xcode for simplicity:

  * `Core`
  * `RacesFeature`

### Module Organization

* Each feature is placed in its own module to isolate logic and support strong test coverage.
* Shared domain logic is located in the **Core** package.
* Reusable UI components would ideally live in a dedicated **UI** package (not included here, but considered).

---

## 🎨 Styling & Accessibility

* The app uses standard SwiftUI components, which provide **basic accessibility support** out of the box.
* **Dark mode** is supported through the use of templates and color definitions for both light and dark themes.

---

## 🧪 Testing

* Testing is focused on the `ViewModel`, as it coordinates interactions between the `View`, `API`, and dependencies.
* This also verifies proper mapping between **API models** and **UI display models**.
* Core functionality is also tested where applicable, as it underpins the feature layer.

> 📌 To run tests, open each `Package.swift` file in Xcode and run tests from the corresponding module.

---

## 🧹 Linting

* **SwiftLint** is configured as a plugin in both the `RacesFeature` and `Core` packages.
* In a larger project, I would integrate linting into a **pre-commit hook** to ensure code quality is enforced automatically.

---

## 🔌 Third-Party Libraries

* **CasePaths** (by Point-Free) is included to improve working with enums—especially useful for pattern matching and testing.

---

## 🛠 Known Issues

* Encountered an issue with `URLSession.shared` not functioning reliably in the iOS 18.4 simulator.

  * Resolved by switching to `.ephemeral` session configuration, as suggested in this [Apple Developer Forum post](https://developer.apple.com/forums/thread/777999).

---

## ⏭ Future Improvements

Time was limited on this project (a few hours across Sunday and Monday, while working full-time), but given more time, I would:

* Enhance styling and accessibility across the app.
* Adopt **The Composable Architecture (TCA)** to better support maintainability and testability.
* Set up the entire app as a **single Swift Package** for a cleaner dependency and build setup.

---

## Free Images Attribution

<a href="https://www.flaticon.com/free-icons/greyhound" title="greyhound icons">Greyhound icons created by Leremy - Flaticon</a>
<a href="https://www.flaticon.com/free-icons/harness-racing" title="harness racing icons">Harness racing icons created by Leremy - Flaticon</a>
<a href="https://www.flaticon.com/free-icons/horse" title="horse icons">Horse icons created by Leremy - Flaticon</a>
<a href="https://www.flaticon.com/free-icons/horse" title="horse icons">Horse icons created by juicy_fish - Flaticon</a>
