# 2D Lyndenmayer-Systems Renderer

This program uses Processing to run. Aditionally, to use this program you need the G4P library installed.

Using user Input, the program uses Turtle Graphcis to render a Lindenmayer system with valids rules and characters.

## Alphabet

The program allow the use of the next symbols:

- **F** : Indicates the turtle will move forward and paint its path.
- **f** : Indicates the turtle will move forward without painting anything.
- **+** : Indicates a right turn.
- **-** : Indicates a left turn.
- **[** : Instantiates a new turtle that copy the orientation of the previous one.
- **]** : Deletes the current turtle and returns to the previous one.
- **Any other letter**: Placeholder. Don't mean any instruction but they can be used to create more complex structures. See example at the end.

## How to use

Once launched, on the left of the window you will have 6 places where you can input information. Next we will explain what does each one mean.

- **Iterations**: The amount of times the rules will be applied.
- **Orientation**: Indicates wich direction will the turtle start drawing.
- **Angle**: Indicates how much the turtle will turn when told so.
- **Axiom**: Initial set of symbols.
- **Rules**: Especial arrangment of symbols that indicates how to substitute them.

### Axiom constraints

It must be a combination of letters in the Alphabet such that for every **[** there's a closing **]** with something in between. There can't be a closing bracket if an opening one wasn't written before.

### How to write Rules

They must be of the form: **Character = Axiom**. 
Write each rule in a separate line.

### Example

Use the next values to try out the program:

- **Iterations**: 7
- **Angle**: 25.7
-  **Axiom**: X
-  **Rules**: X = F[+X]F[-X]+X, F = FF

Other examples, and this one, are lsited in the file "2dStructures.txt".