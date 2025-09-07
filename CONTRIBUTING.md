# Contributing to Camera Gold 🤝

Thank you for your interest in contributing to Camera Gold! We welcome contributions from developers of all skill levels.

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.35.3 or higher
- Android SDK with API level 33+
- Git for version control
- VS Code or Android Studio (recommended)

### Fork and Clone
```bash
# Fork the repository on GitHub, then clone your fork
git clone https://github.com/YOUR-USERNAME/pnhl.git
cd pnhl

# Add upstream remote
git remote add upstream https://github.com/pnhl/pnhl.git
```

### Environment Setup
```bash
# Install Flutter dependencies
cd cameragold
flutter pub get

# Verify setup
flutter doctor

# Run the app
flutter run
```

## 🔄 Development Workflow

### 1. Create Feature Branch
```bash
# Update your main branch
git checkout main
git pull upstream main

# Create feature branch
git checkout -b feature/your-feature-name
```

### 2. Development Guidelines

#### Code Style
- Follow [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Add comments for complex logic
- Format code: `dart format .`

#### Testing
```bash
# Run tests
flutter test

# Test specific file
flutter test test/widget_test.dart

# Generate coverage
flutter test --coverage
```

#### Commit Messages
Use conventional commit format:
```
type(scope): description

feat(camera): add photo filters functionality
fix(auth): resolve login validation bug
docs(readme): update installation instructions
```

### 3. Pull Request Process

#### Before Submitting
- [ ] Code follows style guidelines
- [ ] Tests pass locally
- [ ] Documentation updated if needed
- [ ] No merge conflicts with main branch

#### PR Template
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Performance improvement

## Testing
- [ ] Tested on Android
- [ ] Unit tests added/updated
- [ ] Manual testing completed

## Screenshots (if applicable)
Add screenshots here

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] Tests added/updated
```

## 🐛 Bug Reports

Use GitHub Issues with bug report template:

```markdown
**Bug Description**
Clear description of the bug

**Steps to Reproduce**
1. Go to '...'
2. Click on '...'
3. See error

**Expected Behavior**
What should happen

**Screenshots**
Add screenshots if applicable

**Environment**
- Device: [e.g. Samsung Galaxy S21]
- Android Version: [e.g. 12]
- App Version: [e.g. 1.1.0]
```

## 💡 Feature Requests

```markdown
**Feature Description**
Clear description of the feature

**Problem Statement**
What problem does this solve?

**Proposed Solution**
How should this work?

**Alternatives Considered**
Other approaches considered

**Additional Context**
Any other context or screenshots
```

## 📋 Project Structure

```
cameragold/
├── lib/
│   ├── main.dart           # App entry point
│   ├── models/            # Data models
│   ├── screens/           # UI screens
│   ├── widgets/           # Reusable widgets
│   ├── services/          # API services
│   └── utils/             # Utility functions
├── test/                  # Unit tests
├── android/               # Android configuration
└── assets/                # Images, fonts, etc.
```

## 🎯 Areas for Contribution

### High Priority
- 🔐 User authentication system
- ☁️ Cloud storage integration
- 🎥 Video sharing support
- 📱 iOS version

### Medium Priority
- 🌙 Dark mode theme
- 📍 Location-based features
- 🎨 Photo editing tools
- 🌐 Web version

### Good First Issues
- 🐛 Bug fixes
- 📝 Documentation improvements
- 🎨 UI/UX enhancements
- 🧪 Test coverage

## 📚 Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Material Design Guidelines](https://material.io/design)
- [Android Developer Guide](https://developer.android.com/)

## 👥 Community

- **Issues**: [GitHub Issues](https://github.com/pnhl/pnhl/issues)
- **Discussions**: [GitHub Discussions](https://github.com/pnhl/pnhl/discussions)
- **Email**: contribute@cameragold.app

## 🏆 Recognition

Contributors will be:
- Listed in CONTRIBUTORS.md
- Mentioned in release notes
- Invited to join core team (for significant contributions)

## ❓ Questions?

Don't hesitate to ask! We're here to help:
- Create a [GitHub Discussion](https://github.com/pnhl/pnhl/discussions)
- Email us at: help@cameragold.app

Thank you for contributing to Camera Gold! 🎉
