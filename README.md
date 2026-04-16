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


🔗 Submission Links

Repository URL: https://github.com/ken2796/promom-namespark-lite-ios
Pull Request: (link to open PR from implementation branch → main)


📬 Contact
Kenneth Francia
GitHub: @ken2796
