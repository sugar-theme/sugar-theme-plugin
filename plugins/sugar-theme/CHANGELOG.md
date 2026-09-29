# Sugar Theme plugin changelog

Newest first. Each entry says what changed for you, and what to do, if anything.

## 0.7.0

- The agent now checks for a newer Sugar plugin when you start a task, and offers to update it for you. It always asks first.
- Updating no longer depends on the Update button in the Claude app. After an update, start a new conversation to use it.

## 0.6.2

- Password-protected stores work without turning the password off. Setup notices the password page, asks for the storefront password once and saves it with your project.
- **To do:** in a project set up before this version, run `/sugar-theme:setup` once so it picks up your storefront password.

## 0.6.1

- A pending browser check no longer stops your task. The agent does what you asked and checks the browsers when it first needs them.
- The agent's two browsers start faster and no longer need the internet to start.

## 0.6.0

- Setup runs from `/sugar-theme:setup` after you install the plugin, signs you in to Sugar in the same conversation, and asks whether to keep the plugin updated.
