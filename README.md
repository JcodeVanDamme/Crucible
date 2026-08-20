## About

A 3D Tech Demo built with the Godot Engine. This personal Project was developed to explore 3D development in Godot and grid-based Logic. The core Gameplay revolves around a dynamic Grid where the Player places Dice along Rows and Columns. Continuous Placements push existing dice further into the grid, dynamically updating their 3D rotations and top-facing Values.

## Features

- **Dynamic Tile Detection**: Continuously tracks the Mouse Cursor in real-time to highlight the currently selected Grid Tile and display relevant contextual Information about the active Die.

- **Action-Preview System**: The resulting Changes of the current Die being placed (Updated Positions and Top-Facing-Faces) get previewed when the Placement is locked in. The Selection can either be canceled or commited.

- **Cascading Push Logic**: Implements Grid Manipulation. Placing a Die triggers a propagation Effect across its respective row or column, pushing all affected Dice in the given direction and updating their new states.

- **Action-Based Animations**: All Dice Actions (Currently a Move or Move-Off-Board) feature dedicated, Resource-Based Animations.

- **Global Event Handling**: The Game State is handled via a rudimentary Event-Bus System. The dedicated Systems and Handlers all act in Response to globally emitted Events.

---

## Attribution and protected Assets

See [`CREDITS.md`](docs/api.md) for a complete list of Attributions for the Assets used in this Project.

- **Note**: Because some Asset Licenses prohibit raw Redistribution, those specific Files have been excluded from this repository. As a Result, the Project cannot be run straight out of the Box without substituting the missing Dependencies.

---