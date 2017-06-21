;;-----------------------------line-width-of-80-----------------------------
;; This source file acts as the view and controller.

__includes ["Cell-Instructions.nls" "Cell-Positions.nls"]

breed [cells cell]

cells-own [

  cell_state            ; can be "immature", "mature", "wholly-mature", or "dead"
  age                   ; number of cycles since birth of cell
  split_direction       ; number from 0 to stem-mc which determines the direction of the next split
                        ; see "Defining the Model - Division Angles" in the "Info" tab for directional conventions

  cell_mc               ; maturation cycle of the cell
  cell_wm               ; time to whole maturation of the cell
  cell_ls               ; life span of the cell

  is_stem?              ; flags whether or not the cell is a stem cell
  generation            ; number of generations removed from stem cell
  branch_direction      ; number corresponding to the branch number that cell belongs to. Convention is the same as
                        ; split_direction's  [-  so it's parent?]<-Ben

  neighbor_cells        ; ordered list of cells immediately linked as neighbors (or "nobody"). The index of the cell
                        ; on the list defines the direction of the neighbor according to the same convention as thesplit_direction

  cxcor2D               ; theoretical x coordinate of the cell as laid out in two dimensions
  cycor2D               ; theoretical y coordinate of the cell as laid out in two dimensions

  visited?              ; multi-use flag that can be set/reset for the purposes of tree traversal
]


to Setup
  clear-all
  SetupCellInstructions            ; from Cell-Instructions.nls; creates initial stem cell
  FormatCells
  ask cell 0 [ set heading 90 ]
  reset-ticks
end

to Go
  ; call to cell-instructions to advance cell activity
  GoCellInstructions             ; from Cell-Instructions.nls

  ; call to Draw function to display cells
  Draw

  tick
end

;; ReDraw the cell structure
to Draw
  if any? cells [
    ; call to position-cells which places all cells in appropriate position
    CellPosition

    ; if the true coordinates exceed the size of the world, then hide the turtle and move it to an inconsequential position
    ; otherwise update the displayed position to match the true position
    ask cells [
      ifelse (abs cxcor2D >= max-pxcor) or (abs cycor2D >= max-pycor)  [
        hide-turtle
        setxy max-pxcor max-pycor
      ][
      setxy cxcor2D cycor2D
      ]
    ]

    ; call to format-cell function which defines superficial shapes and color
    FormatCells
  ]
end

;; Set desired shapes and colors based on cell state
to FormatCells
  ask cells [
    if cell_state = "immature" [ set color red set shape "hex-arrow"]
    if cell_state = "mature" [ set color blue set shape "hex-arrow"]
    if cell_state = "wholly-mature" [ set color green - 3 set shape "hex"]
    if cell_state = "dead" [ hide-turtle ]

    if is_stem? [
      set color white
    ]
  ]
end

;; Set up a "small world" where there are fewer, larger patches
;; Use for close examination of individual cell activity
to SmallWorld
  set-patch-size 13
  resize-world (0 - 17) 17 (0 - 17) 17
  Setup
end

;; Set up a "large world" where there are more, smaller patches
;; Use for macroscopic view of the cellular structure
to LargeWorld
  set-patch-size 3
  resize-world (0 - 75) 75 (0 - 75) 75
  Setup
end
@#$#@#$#@
GRAPHICS-WINDOW
256
10
719
474
-1
-1
13.0
1
10
1
1
1
0
0
0
1
-17
17
-17
17
0
0
1
ticks
30.0

SLIDER
26
150
127
183
stem-mc
stem-mc
2
10
2.0
2
1
NIL
HORIZONTAL

BUTTON
35
43
96
76
NIL
setup\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
96
43
159
76
step
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
733
17
798
62
Live Cells
count cells with [cell_state != \"dead\"]
17
1
11

SLIDER
127
150
228
183
lifespan
lifespan
0
200
25.0
1
1
NIL
HORIZONTAL

BUTTON
35
10
128
43
small-world
SmallWorld
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
128
10
232
43
large-world
LargeWorld
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
7
113
153
146
immortal-stem-cell?
immortal-stem-cell?
0
1
-1000

MONITOR
798
17
886
62
Max Generation
[generation] of max-one-of cells [generation]
17
1
11

MONITOR
886
17
995
62
% Wholly Mature
count cells with [cell_state = \"wholly-mature\"] / count cells with [cell_state != \"dead\"]
5
1
11

PLOT
732
218
996
346
Cell type count vs Distance along crypt
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"Immature" 1.0 0 -2674135 true "set-plot-x-range 0 max-pxcor" "histogram [ round distance cell 0 ] of cells with [cell_state = \"immature\"]"
"Maturing" 1.0 0 -13345367 true "" "histogram [ round distance cell 0 ] of cells with [cell_state = \"maturing\"]"
"Fully Mature" 1.0 0 -6459832 true "" "histogram [ round distance cell 0 ] of cells with [cell_state = \"fully-mature\"]"

BUTTON
159
43
222
76
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
26
183
127
216
gen1-mc
gen1-mc
0
6
6.0
1
1
NIL
HORIZONTAL

SLIDER
26
216
127
249
gen2-mc
gen2-mc
0
6
6.0
1
1
NIL
HORIZONTAL

SLIDER
26
249
127
282
gen3-mc
gen3-mc
0
6
6.0
1
1
NIL
HORIZONTAL

SLIDER
26
282
127
315
gen4-mc
gen4-mc
0
6
6.0
1
1
NIL
HORIZONTAL

SLIDER
26
315
127
348
gen5-mc
gen5-mc
0
6
6.0
1
1
NIL
HORIZONTAL

SLIDER
127
183
228
216
gen1-wm
gen1-wm
0
12
10.0
1
1
NIL
HORIZONTAL

SLIDER
127
216
228
249
gen2-wm
gen2-wm
0
12
9.0
1
1
NIL
HORIZONTAL

SLIDER
127
249
228
282
gen3-wm
gen3-wm
0
12
8.0
1
1
NIL
HORIZONTAL

SLIDER
127
282
228
315
gen4-wm
gen4-wm
0
12
7.0
1
1
NIL
HORIZONTAL

SLIDER
127
315
228
348
gen5-wm
gen5-wm
0
12
6.0
1
1
NIL
HORIZONTAL

SWITCH
153
113
251
146
angle-shift
angle-shift
1
1
-1000

SWITCH
7
80
97
113
rabbit?
rabbit?
1
1
-1000

SWITCH
97
80
251
113
no-whole-maturation?
no-whole-maturation?
1
1
-1000

SLIDER
26
348
127
381
gen6-mc
gen6-mc
0
6
6.0
1
1
NIL
HORIZONTAL

SLIDER
26
381
127
414
gen7-mc
gen7-mc
0
6
6.0
1
1
NIL
HORIZONTAL

SLIDER
26
414
127
447
gen8-mc
gen8-mc
0
6
6.0
1
1
NIL
HORIZONTAL

SLIDER
26
447
127
480
gen9-mc
gen9-mc
0
6
6.0
1
1
NIL
HORIZONTAL

SLIDER
127
348
229
381
gen6-wm
gen6-wm
0
12
5.0
1
1
NIL
HORIZONTAL

SLIDER
127
381
229
414
gen7-wm
gen7-wm
0
12
4.0
1
1
NIL
HORIZONTAL

SLIDER
127
414
229
447
gen8-wm
gen8-wm
0
12
3.0
1
1
NIL
HORIZONTAL

SLIDER
127
447
229
480
gen9-wm
gen9-wm
0
12
2.0
1
1
NIL
HORIZONTAL

SLIDER
26
480
127
513
gen10-mc
gen10-mc
0
6
6.0
1
1
NIL
HORIZONTAL

SLIDER
127
480
229
513
gen10-wm
gen10-wm
0
12
1.0
1
1
NIL
HORIZONTAL

@#$#@#$#@
## BACKGROUND

This program serves as a tool for modeling cell division according to current research in agent-based mathematical modeling of cell reproduction. One of the important unexplained phenomena of cellular biology is the observation of "dynamic stability". The vast majority of the human organs consist of cells that are constantly dividing and dying within a timescale that is much shorter than the human lifespan. Remarkably, organs remain macroscopically stable and intact despite the perpetual turnover. This leads to the concept of dynamic stability. While many classes of tissue exhibit this behavior, this research focuses on modeling dynamic stability as seen in the colonic crypt to reduce the scope.

While organs are highly intricate structures, it is assumed to be unlikely that the cells possess the complexity to explictly know their place and role within the macroscopic organ. Instead, this research is predicated upon the possibility of "emergent complexity". In the field of agent-based modeling, there is well documented research in a multitude of domains whereby highly interesting behavior is observed from the interactions between highly simplistic agents. This research presupposes that dynamically stable cell structures are an instance of emergent complexity. The purpose of this research, therefore, is to explore the possible rules that might govern the cells in these structures.

This set of programs in particular is aimed at modeling the variety of cell structures that results from implemented several conjectured rules of cell division. Both the temporal as well as spatial rules of cell division are captured in this programs.

## Included Files

The interactive portion of the program is organized into two separate interfaces. These are linked by two additional source files which define the underlying model. A description of each file is described below.

2D-Cell-Structure

This file is an interface in the standard Netlogo software which models the crypt structure in two dimensions. While running this model, the user should be envisioning the possibility for this 2-D structure to be "folded up" into a more tubular crypt shape.

The choice of two dimensions abstracts a layer of simplicity while experimenting with the parameters. More importantly, it also greatly reduces the run time. It is recommended that any initial behaviorspace-like searches for interesting rules are applied here.

3D-Cell-Structure

This file is an interface in the 3D version of Netlogo that models the crypt in three dimensions. The display shows the standard 2-D model projected onto a tubular shape that takes the form of a bottom hemisphere attached to an upper cylinder. This model takes more computing resources to run and is better used for single-trial experiments. While the controls are identical to the ones found in the 2-D interface to ensure consistency, the the full range of numerical plots and monitors are not provided.

Cell-Instructions

All functions associated with the model are housed in the Cell-Instructions file. The code includes its own version of "setup" and "go". In theory, a full mathematical definition of the cell structure could be attained from only methods in this file.

Cell-Positions

All functions associated with calculating the theoretical spatial locations of the cells are located in Cell-Positions. The file contains functions for extracting both 2-D and 3-D positions from adjacency relationships tracked by the Cell-Instructions file. Note that the displayed positions themselves are set in the interface to avoid the possibility of plotting outside of the display.

## Defining the Model - Cell Properties

The model is formulated as an agent-based model with the only agents being the cells themselves. All cells have three changing properties: age, split-direction, and cell-state. Since cells divide asymmetrically in this model, it is possible to distinguish the resultant cells into a “child” and a “parent”. The age of a cell is then defined by the number of discrete time steps since a cell split from its parent. The split-direction dictates the next angle of division. Split-direction is a integer number that is better defined later in the "Cell-Positions" section. The cell-state is a string that defines the current state of the cell lifecycle ("immature", "mature", "wholly-mature", or "dead").

The progression of each cell through various states is defined by three immutable properties: a maturation-cycle, a time to reach whole-maturation, and a lifespan. These are abbreviated as mc, wm, and ls and correspond to the variables cell-mc, cell-wm, and cell-ls, respectively. The values specify the age at which cells change state. Beginning at age zero, a cell is “immature”. At age mc, a cell becomes “mature”.  At age wm, a cell becomes “wholly-mature” and at age ls, the cell has reached the end of its life cycle and becomes “dead”. Cells will divide if and only if it is in its “mature” state.

The neighbor-cells property tracks the adjacent neighbors of each cell. These are used to update the five coordinate variables (cxcor2D, cycor2D, cxcor3D, cycor3D, and czcor3D) that define cell position in 2D and 3D space.

Cells also have several properties that distinguish evolution: is-stem?, generation, and branch-direction. These remain underchanging throughout a cell's life. Generation and is-stem? affect the mc, wm, and ls values that a cell inherits at birth.
Branch-direction indirectly affects the initial angle of division as well as the 3-D coordinate mappings. Effectively, all cells that share these properties in common have identical life cycles.

Finally, "overlap?" and "visited?" exist primarily for instrumental purposes and are not key parts of the model.

## Defining the Model - Division Angles

Prior research has shown that the maturation cycle defines the number of discrete directions in which a cell can divide. For instance, cells with mc = 2 can only divide in 180 degree increments, cells with mc = 4 can divide in 90 degree increments, and cells with mc = 6 can divide in 60 degree increments, and so on. The split angle is tracked and updated even while a cell is immature. The initial split angle of a cell is the split angle of its parent, or the split angle of its parent minus 1 / mc_stem revolutions, if angle-shift? is set to true. This split angle is continually turned counterclockwise by 1 / mc revolutions every time step up until the cell becomes wholly-mature.

The program tracks the split angle by way of the "split-direction" cell property. Whereas split angle is measured in degrees, split-direction is an integer from 1 to the mc value of the stem cell, since the stem cell defines the tiling scheme for the entire structure. The split angle is defined in the standard mathematical convention (with 0 degrees oriented along the positive x axis and counterclockwise being the positive direction), and the split-direction is defined by the following:

	split-direction = split-angle * (mc_stem / 360)

For instance, a cell with mc = 6 would divide at 0, 60, 120, 180, 240, and 300 degrees, which corresponds to split-directions of 0, 1, 2, 3, 4, and 5, respectively.

Defining split-direction in this way allows for the tracking of neighbors in the form of an ordered list. Each cell has a variable which stores a list of neighbors the size of the stem cell's mc value. By this scheme, the "ith" neighbor in the list corresponds to the neighor in the "ith" split-direction. Neighbors are "nobody" if a neighbor does not exist.

When a cell divides, it first checks the list to see if a neighbor exists in the split-direction. One of three things can happen:

 - Case 1: Nobody in the split-direction - A new cell is created and placed in the list
 - Case 2: Dead cell in the split-direction - The connections to and from the dead cell are kept in tact. All other properties are reset, causing the cell to be "reborn"
 - Case 3: Live cell in the split-direction - The new cell is created and replaces the old cell in the split-direction index of the list. The old cell is placed in the split-direction index of the new cell's list. Finally, the new cell is placed in the index opposite of the split-direction in the old cell's list. These steps ensure the appropriate connections are maintained.

The result of every cell tracking an ordered list of neighbors is a connected network that is analagous to a tree data structure rooted at the stem cell. From this structue, the positioning functions can extract all necessary data to define the relative spatial coordinates of the cell.

## Defining the Model - Cell Positions

All cell positions are attained from the implicity information gained from neighbor relationships of the tree data structure mentioned above. Cells have two sets of positions that track both their coordinates in 2-D and 3-D.

2-D Coordinates:

The stem cell is defined to be at (x = 0, y = 0). All cells are exactly one unit distance away from each of their immediate neighbors in the direction defined by their place on the neighbors list. Cells are plotted in breadth-first order. The stem cells is plotted first. Next, the direct neighbors of the stem cells are plotted in the appropriate directions, followed by the direct neighbors of those cells and so on until all cells have a correctly defined position.

3-D Coordinates:

The 3-D coordinates are derived from the 2-D coordinates based on a key "crypt-circumference" parameter. This parameter defines both the size of the bottom hemisphere as well as the top cylinder parts of the crypt. Cells are plotted in 3-D with respect to their original branch direction. First, cell positions are projected onto a reference axis defined by their branch direction from the original stem cell. The distance along the axis to this projection is used to determine the distance of the cell up the crypt. Meanwhile, the orthogonal distance from the original cell coordinate to the axis projection defines any radial displacement of the final cell coordinate from the axis.

## Interface

The following controls are provided in the interface.

- small-world - Initialies a new model with a small area and high resolution.

- large-world - Initializes a new model with a large area and low resolution.

- setup - Initializes a new model under the current area and resolution setting. Area size and resolution are manually adjustable by right clicking the display area and clicking "edit".

- step - Advances the model by one time step

- go - Advances the model continuously. Click the go button again to stop the model.

- rabbit? - If set to on, cells start to divide on the time step after they reach whole-maturation. Otherwise, cells divide on the same time step when they reach whole-maturation.

- no-whole-maturation? - If set to on, cells never reach whole-maturation and are fertile for the duration of their lifespan. Otherwise, cells reach whole-maturation according to the gen1-wm, gen2-wm.... gen10-wm sliders below.

- angle-shift? - If set to on, cells with an odd mc value will inherit a split-direction equal to its parent's split-direction minus one. Otherwise, all cells inherit the exact split-direction of its parents.

- immortal-stem-cell? - If set to on, the stem cell will never die. Otherwise, it dies once its age exceeds the lifespan slider.

- stem-mc - Determines the maturation cycle of the stem cell. This also sets the number of neighbors that all other cells have and therefore defines the tiling scheme for all cells.

- lifespan - Determines the lifespan for all cells, except for possibly the stem cell.

- gen1-mc ... gen10-mc - Determines the maturation cycle value for each generation of cells. Note that values MUST be a factor of the stem-mc value. E.g. if the stem-mc is 6, then allowable values for gen1-mc ... gen10-mc are 1, 2, 3, or 6. Setting the value to 0 is also acceptable and equivalent to defining the generation of cells to be completely infertile.

- gen1-wm ... gen10-wm - Determines the time to whole maturation for each generation of cells.

Visual displays are defined by the following.

- Stem Cells - colored white
- Immature Cells - colored red
- Mature Cells - colored blue
- Wholly Mature Cells - colored dark green
- Overlapping Cells - colored yellow (regardless of the cell type)
- Arrows - arrows on immature and mature cells point to the next split direction

## Suggested Settings

No Whole Maturation: Creates a non-steady-state condition where cells grow exponentially. While this is not a realistic condition, it is mathematically noteworthy in its perfect avoidance of overlaps.

- rabbit: off
- no-whole-maturation?: on
- immortal-stem-cell?: on
- angle-shift?: off
- stem-mc: 6
- lifespan: 200
- gen1-mc ... gen10-mc: 6, 6, 6 ... 6
- gen1-wm ... gen10-wm: irrelevant, since "no-whole-maturation?" is on

Linearly Diminishing Whole Maturation: Creates the most basic steady-state condition. The tapering off of the generational wm values and a finite lifespan effectively caps the population size.

- rabbit: off
- no-whole-maturation?: off
- immortal-stem-cell?: on
- angle-shift?: off
- stem-mc: 6
- lifespan: 25
- gen1-mc ... gen10-mc: 6, 6, 6 ... 6
- gen1-wm ... gen10-wm: 10, 9, 8, 7, 6, 5, 4, 3, 2, 1

Linearly Diminishing Snowflake Pattern: Similar to the above setting but illustrates one of the more interesting patterns that can arise from even slight changes in parameters.

- rabbit: off
- no-whole-maturation?: off
- immortal-stem-cell?: on
- angle-shift?: off
- stem-mc: 6
- lifespan: 25
- gen1-mc ... gen10-mc: 6, 2, 3, 3, 2, 0, 0, 0, 0, 0
- gen1-wm ... gen10-wm: 8, 7, 6, 5, 4, 3, 2, 1, 0, 0

Ideal Crypt Structure 1: Creates an "ideal" crypt structure in the sense that there are minimal overlaps and perfectly packed walls

- rabbit: off
- no-whole-maturation?: off
- immortal-stem-cell?: on
- angle-shift?: on
- stem-mc: 6
- lifespan: 200
- gen1-mc ... gen10-mc: 3, 2, 0 ... 0
- gen1-wm ... gen10-wm: 5, 4, 0 ... 0

Ideal Crypt Structure 2: Creates an "ideal" crypt structure in the sense that there are minimal overlaps and perfectly packed walls

- rabbit: off
- no-whole-maturation?: off
- immortal-stem-cell?: on
- angle-shift?: on
- stem-mc: 6
- lifespan: 200
- gen1-mc ... gen10-mc: 1, 0 ... 0
- gen1-wm ... gen10-wm: 8, 0 ... 0
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

hex
true
0
Polygon -7500403 true true 0 150 75 30 225 30 300 150 225 270 75 270

hex-arrow
true
0
Polygon -7500403 true true 0 150 75 30 225 30 300 150 225 270 75 270
Polygon -16777216 true false 150 75 90 210 150 180 210 210 150 75

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="Immortal Stem Cell / Decaying Branches Comprehensive" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>terminate-behaviorspace</exitCondition>
    <metric>circumference</metric>
    <metric>overlap-percentage</metric>
    <enumeratedValueSet variable="life-span">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="full-maturation">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rabbit?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="maturation-cycle">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="immortal-stem-cell?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="gen1-mc">
      <value value="0"/>
      <value value="1"/>
      <value value="2"/>
      <value value="3"/>
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="gen2-mc">
      <value value="0"/>
      <value value="1"/>
      <value value="2"/>
      <value value="3"/>
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="gen3-mc">
      <value value="0"/>
      <value value="1"/>
      <value value="2"/>
      <value value="3"/>
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="gen4-mc">
      <value value="0"/>
      <value value="1"/>
      <value value="2"/>
      <value value="3"/>
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="gen5-mc">
      <value value="0"/>
      <value value="1"/>
      <value value="2"/>
      <value value="3"/>
      <value value="6"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
