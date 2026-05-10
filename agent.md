# Agent Guidelines & Context

This document provides context and guidelines for AI agents (like Trae, Cursor, or GitHub Copilot) working on the Lumen Noise project.

## Project Context
Lumen Noise is an ambient clock and soundscape app for the Apple ecosystem (iOS, iPadOS, macOS, tvOS). The project consists of a SwiftUI-based app and a static marketing/support website.

## Coding Standards

### SwiftUI (App)
- **Architecture**: Follow standard SwiftUI patterns with a focus on state management (State/Binding/Environment).
- **UI/UX**: Prioritize "Liquid Glass" design principles—smooth animations, subtle gradients, and high legibility.
- **Performance**: Ensure ambient animations are energy-efficient to prevent battery drain.

### Web (docs/)
- **Technology**: Vanilla HTML5 and CSS3. No heavy frameworks (React/Vue) unless explicitly requested.
- **Styling**: Maintain the design system defined in `docs/styles.css`. Use CSS variables for colors and spacing.
- **Interactive Elements**: Use lightweight, vanilla JavaScript with proper error handling and event object validation (see `docs/index.html` for patterns).

## Key Components

### Website Navigation
- When adding new pages, ensure links are updated in the header `<nav>` and footer of `index.html`, `support.html`, and `privacy.html`.

### Screen Carousel
- The device screenshots in `docs/index.html` use a custom carousel implementation. 
- To add a new screenshot:
  1. Add the image to `docs/assets/`.
  2. Update the corresponding `carousel-track` in the HTML.
  3. Ensure the `moveCarousel` function is called with the correct `tabId` and `event`.

## Important Files
- [LumenApp.swift](file:///Users/jihongbo/Desktop/Lumen/Lumen/LumenApp.swift): Main entry point for the Apple app.
- [styles.css](file:///Users/jihongbo/Desktop/Lumen/docs/styles.css): Global design system for the website.
- [index.html](file:///Users/jihongbo/Desktop/Lumen/docs/index.html): Main landing page with device mockups and carousels.

## Future Roadmap
- Implementation of more soundscapes.
- Enhancement of the "Liquid Glass" visual effects.
- Internationalization (i18n) for both the app and the website.
