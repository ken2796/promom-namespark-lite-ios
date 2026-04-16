ProMomStarter – iOS
A starter iOS project submitted as a take-home assignment. This document covers everything needed to run, review, and evaluate the submission.

📋 Submission Checklist

 Public GitHub repository URL submitted
 Open pull request from implementation branch → default branch (main)
 At least one targeted unit/UI test included


🚀 Local Run Instructions
Requirements
ToolVersionXcode15.0 or lateriOS Deployment TargetiOS 16.0+macOSVentura 13.0+Swift5.9+
Steps
bash# 1. Clone the repository
git clone https://github.com/ken2796/promom-namespark-lite-ios.git
cd promom-namespark-lite-ios

# 2. Open the project in Xcode
open ProMomStarter.xcodeproj

# 3. Select a simulator or connected device
# (e.g., iPhone 15 Pro – iOS 17)

# 4. Build and run
# Press Cmd + R  or  Product → Run

No external package managers (CocoaPods / SPM) are required unless noted in the project.
If there are Swift Package dependencies, Xcode will resolve them automatically on first build.

Running Tests
bash# Via Xcode
# Press Cmd + U  or  Product → Test

# Via command line
xcodebuild test \
  -project ProMomStarter.xcodeproj \
  -scheme ProMomStarter \
  -destination 'platform=iOS Simulator,name=iPhone 15'

⚖️ Tradeoffs & Known Limitations
AreaDecision / LimitationArchitectureUsed a simple MVC/MVVM structure for speed; a full Clean Architecture would be more scalableState ManagementLocal state only — no persistence layer (CoreData / UserDefaults) implemented yetError HandlingBasic error alerts shown; no retry logic or offline supportUI PolishFunctional UI implemented; animations and accessibility (VoiceOver) were deferredTesting CoverageTargeted tests written for core logic; full coverage was out of scope for the timelineNetworkingHardcoded base URLs; should be moved to a config/environment fileLocalizationEnglish only; Localizable.strings not yet set up

🤖 Where AI Was Used
AI assistance (Claude / ChatGPT) was used in the following areas:

Boilerplate generation – Initial project structure, view controller scaffolding, and model definitions
Unit test stubs – AI generated initial XCTestCase skeletons for core business logic
Git workflow guidance – Helped troubleshoot git initialization, branch naming, and push errors during setup
README drafting – This document was drafted with AI assistance and then reviewed and edited manually
Code comments – AI suggested inline documentation for complex functions


✅ How AI Output Was Validated

All AI-generated code was read line by line before being committed
Logic was manually traced against expected inputs and outputs
Unit tests were run to verify AI-generated functions produced correct results
UI was tested on simulator to confirm AI-generated layouts rendered correctly
Any AI suggestion involving architecture or patterns was cross-checked against Apple's official documentation


✏️ Where AI Output Was Rewritten or Rejected
AI SuggestionAction TakenReasonGeneric ViewController with no separation of concernsRewrittenRefactored into ViewModel to follow MVVMForce-unwrapped optionals (!) in generated codeRewrittenReplaced with safe guard let / if let unwrappingOverly verbose test namingEditedRenamed tests to follow test_<method>_<condition>_<expectedResult> conventionSuggested using a third-party networking libraryRejectedUsed URLSession directly to keep dependencies minimalAuto-generated comments that stated the obviousRejectedRemoved noise; kept only meaningful documentation

🔧 What I Would Refactor Next

Extract networking into a dedicated service layer – Currently mixed with view logic
Add dependency injection – Makes unit testing easier and reduces tight coupling
Implement proper error types – Replace generic Error with a typed AppError enum
Add Coordinator pattern – Navigation logic is currently inside view controllers
Set up CI/CD – GitHub Actions for automated build and test on pull requests
Increase test coverage – Add integration tests and UI tests with XCUITest
Add environment configuration – Separate dev / staging / production configs


⏭️ Skipped Tasks & Reasons
Skipped TaskReasonOffline/cache supportOut of scope for the starter; requires CoreData or a caching strategyFull accessibility supportTime constraint; VoiceOver labels and Dynamic Type were deprioritizedDark mode polishBasic system colors used; custom dark mode assets not createdLocalizationSingle-language app; internationalization deferred to a future sprintAnalytics / loggingNo analytics SDK integrated; would add Firebase or similar in productionFull test suiteOnly targeted tests written; comprehensive coverage requires more time

📁 Project Structure
ios/
├── ProMomStarter/
│   ├── Models/
│   ├── Views/
│   ├── ViewModels/
│   └── Resources/
├── ProMomStarterTests/
│   └── (Unit Tests)
├── ProMomStarter.xcodeproj
└── README.md

🔗 Submission Links

Repository URL: https://github.com/ken2796/promom-namespark-lite-ios
Pull Request: (link to open PR from implementation branch → main)


📬 Contact
Kenneth Francia
GitHub: @ken2796
